<?php

declare(strict_types=1);

namespace App\Http\Controllers\Api\V1;

use App\Http\Requests\Api\V1\Auth\LoginRequest;
use App\Http\Requests\Api\V1\Auth\RegisterRequest;
use App\Http\Resources\Api\V1\UserResource;
use App\Models\User;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;
use Symfony\Component\HttpFoundation\Response;
use Throwable;

final class AuthController extends ApiController
{
    public function register(
        RegisterRequest $request
    ): JsonResponse {
        $data = $request->validated();

        try {
            /** @var User $user */
            $user = DB::transaction(
                function () use ($data): User {
                    $user = User::query()->create([
                        'name' =>
                            $data['name'],

                        'email' =>
                            $data['email'],

                        'username' =>
                            $data['username'],

                        'house_code' =>
                            $data['house_code'],

                        'address' =>
                            $data['address'],

                        'phone' =>
                            $data['phone'],

                        'password' =>
                            $data['password'],

                        /*
                         * Akun registrasi belum boleh login
                         * sampai diverifikasi Pengurus RT.
                         */
                        'is_active' => false,

                        'verification_status' =>
                            'pending',

                        'verified_at' => null,

                        'verified_by' => null,

                        'rejection_reason' => null,
                    ]);

                    $user->assignRole('warga');

                    return $user;
                }
            );
        } catch (Throwable $exception) {
            report($exception);

            return $this->error(
                'Registrasi gagal. Silakan coba kembali.',
                Response::HTTP_INTERNAL_SERVER_ERROR,
            );
        }

        return $this->success(
            [
                'user' =>
                    (new UserResource($user))
                        ->resolve($request),

                'verification_status' =>
                    'pending',
            ],
            'Registrasi berhasil. Akun Anda sedang menunggu verifikasi Pengurus RT.',
            Response::HTTP_CREATED,
        );
    }

    public function login(
        LoginRequest $request
    ): JsonResponse {
        /**
         * @var array{
         *     username: string,
         *     password: string,
         *     device_name: string
         * } $credentials
         */
        $credentials = $request->validated();

        $user = User::query()
            ->where(
                'username',
                $credentials['username']
            )
            ->first();

        if (
            $user === null
            || ! Hash::check(
                $credentials['password'],
                $user->password
            )
        ) {
            return $this->error(
                'Username atau password tidak sesuai.',
                Response::HTTP_UNAUTHORIZED,
                [
                    'credentials' => [
                        'Username atau password tidak sesuai.',
                    ],
                ],
            );
        }

        if ($user->verification_status === 'pending') {
            return $this->error(
                'Akun Anda sedang menunggu verifikasi Pengurus RT.',
                Response::HTTP_FORBIDDEN,
            );
        }

        if ($user->verification_status === 'rejected') {
            $message = filled(
                $user->rejection_reason
            )
                ? 'Registrasi akun ditolak: '
                    .$user->rejection_reason
                : 'Registrasi akun Anda ditolak oleh Pengurus RT.';

            return $this->error(
                $message,
                Response::HTTP_FORBIDDEN,
            );
        }

        if (
            $user->verification_status
            !== 'verified'
        ) {
            return $this->error(
                'Status verifikasi akun tidak valid. Hubungi Pengurus RT.',
                Response::HTTP_FORBIDDEN,
            );
        }

        if (! $user->is_active) {
            return $this->error(
                'Akun Anda sedang tidak aktif. Hubungi Pengurus RT.',
                Response::HTTP_FORBIDDEN,
            );
        }

        if (! $user->isWarga()) {
            return $this->error(
                'Akun ini tidak memiliki akses ke aplikasi warga.',
                Response::HTTP_FORBIDDEN,
            );
        }

        $plainTextToken = $user
            ->createToken(
                $credentials['device_name'],
                ['mobile:warga']
            )
            ->plainTextToken;

        return $this->success(
            [
                'token_type' =>
                    'Bearer',

                'access_token' =>
                    $plainTextToken,

                'user' =>
                    (new UserResource($user))
                        ->resolve($request),
            ],
            'Login berhasil.',
        );
    }

    public function me(
        Request $request
    ): JsonResponse {
        /** @var User $user */
        $user = $request->user();

        return $this->resource(
            new UserResource($user)
        );
    }

    public function logout(
        Request $request
    ): JsonResponse {
        /** @var User $user */
        $user = $request->user();

        $accessToken =
            $user->currentAccessToken();

        if (
            $accessToken !== null
            && method_exists(
                $accessToken,
                'delete'
            )
        ) {
            $accessToken->delete();
        }

        return $this->success(
            null,
            'Logout berhasil.'
        );
    }
}
