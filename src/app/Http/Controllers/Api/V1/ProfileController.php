<?php

declare(strict_types=1);

namespace App\Http\Controllers\Api\V1;

use App\Http\Requests\Api\V1\UpdateProfileRequest;
use App\Http\Resources\Api\V1\UserResource;
use App\Models\User;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

final class ProfileController extends ApiController
{
    public function show(Request $request): JsonResponse
    {
        /** @var User $user */
        $user = $request->user();

        return $this->resource(new UserResource($user));
    }

    public function update(UpdateProfileRequest $request): JsonResponse
    {
        /** @var User $user */
        $user = $request->user();

        $data = $request->safe()->only([
            'email',
            'phone',
            'password',
        ]);

        $passwordChanged = array_key_exists('password', $data);

        $user->fill($data);
        $user->save();

        if ($passwordChanged) {
            $accessToken = $user->currentAccessToken();
            $currentTokenId = $accessToken !== null && method_exists($accessToken, 'getKey')
                ? $accessToken->getKey()
                : null;

            if ($currentTokenId !== null) {
                $user->tokens()
                    ->where('id', '!=', $currentTokenId)
                    ->delete();
            } else {
                $user->tokens()->delete();
            }
        }

        return $this->resource(
            new UserResource($user->refresh()),
            'Profil berhasil diperbarui.',
        );
    }
}
