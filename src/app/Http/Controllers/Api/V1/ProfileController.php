<?php

declare(strict_types=1);

namespace App\Http\Controllers\Api\V1;

use App\Http\Requests\Api\V1\UpdateAvatarRequest;
use App\Http\Requests\Api\V1\UpdateProfileRequest;
use App\Http\Resources\Api\V1\UserResource;
use App\Models\User;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;

final class ProfileController extends ApiController
{
    public function show(
        Request $request
    ): JsonResponse {
        /** @var User $user */
        $user = $request->user();

        return $this->resource(
            new UserResource($user)
        );
    }

    public function update(
        UpdateProfileRequest $request
    ): JsonResponse {
        /** @var User $user */
        $user = $request->user();

        /*
         * Hanya field berikut yang boleh diubah
         * langsung oleh warga.
         *
         * house_code, address, role,
         * verification_status dan is_active
         * tidak boleh diubah dari mobile.
         */
        $data = $request->safe()->only([
            'name',
            'username',
            'email',
            'phone',
            'password',
        ]);

        $passwordChanged =
            array_key_exists(
                'password',
                $data
            );

        $user->fill($data);
        $user->save();

        /*
         * Jika password diganti, cabut token
         * login lain tetapi pertahankan sesi
         * yang sedang digunakan.
         */
        if ($passwordChanged) {
            $accessToken =
                $user->currentAccessToken();

            $currentTokenId =
                $accessToken !== null
                && method_exists(
                    $accessToken,
                    'getKey'
                )
                    ? $accessToken->getKey()
                    : null;

            if ($currentTokenId !== null) {
                $user
                    ->tokens()
                    ->where(
                        'id',
                        '!=',
                        $currentTokenId
                    )
                    ->delete();
            } else {
                $user->tokens()->delete();
            }
        }

        return $this->resource(
            new UserResource(
                $user->refresh()
            ),
            'Profil berhasil diperbarui.'
        );
    }

    public function updateAvatar(
        UpdateAvatarRequest $request
    ): JsonResponse {
        /** @var User $user */
        $user = $request->user();

        $avatar =
            $request->file('avatar');

        /*
         * Hapus foto profil lama jika ada.
         */
        if (
            filled($user->avatar_url)
            && Storage::disk('public')
                ->exists(
                    (string) $user->avatar_url
                )
        ) {
            Storage::disk('public')
                ->delete(
                    (string) $user->avatar_url
                );
        }

        $path = $avatar->store(
            'avatars',
            'public'
        );

        $user->update([
            'avatar_url' => $path,
        ]);

        return $this->resource(
            new UserResource(
                $user->refresh()
            ),
            'Foto profil berhasil diperbarui.'
        );
    }
}
