<?php

declare(strict_types=1);

namespace App\Http\Controllers\Api\V1;

use App\Http\Requests\Api\V1\Auth\LoginRequest;
use App\Http\Resources\Api\V1\UserResource;
use App\Models\User;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Symfony\Component\HttpFoundation\Response;

final class AuthController extends ApiController
{
    public function login(LoginRequest $request): JsonResponse
    {
        /** @var array{username: string, password: string, device_name: string} $credentials */
        $credentials = $request->validated();

        $user = User::query()
            ->where('username', $credentials['username'])
            ->first();

        if ($user === null || ! Hash::check($credentials['password'], $user->password)) {
            return $this->error(
                'Username atau password tidak sesuai.',
                Response::HTTP_UNAUTHORIZED,
                ['credentials' => ['Username atau password tidak sesuai.']],
            );
        }

        if (! $user->is_active) {
            return $this->error(
                'Akun Anda sedang tidak aktif. Hubungi Ketua RT.',
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
            ->createToken($credentials['device_name'], ['mobile:warga'])
            ->plainTextToken;

        return $this->success([
            'token_type' => 'Bearer',
            'access_token' => $plainTextToken,
            'user' => (new UserResource($user))->resolve($request),
        ], 'Login berhasil.');
    }

    public function me(Request $request): JsonResponse
    {
        /** @var User $user */
        $user = $request->user();

        return $this->resource(new UserResource($user));
    }

    public function logout(Request $request): JsonResponse
    {
        /** @var User $user */
        $user = $request->user();
        $accessToken = $user->currentAccessToken();

        if ($accessToken !== null && method_exists($accessToken, 'delete')) {
            $accessToken->delete();
        }

        return $this->success(null, 'Logout berhasil.');
    }
}
