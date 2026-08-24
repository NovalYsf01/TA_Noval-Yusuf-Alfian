<?php

declare(strict_types=1);

namespace App\Http\Controllers\Api\V1;

use App\Http\Requests\Api\V1\DeleteDeviceTokenRequest;
use App\Http\Requests\Api\V1\StoreDeviceTokenRequest;
use App\Http\Resources\Api\V1\DeviceTokenResource;
use App\Models\DeviceToken;
use App\Models\User;
use Illuminate\Http\JsonResponse;

final class DeviceTokenController extends ApiController
{
    public function store(StoreDeviceTokenRequest $request): JsonResponse
    {
        /** @var User $user */
        $user = $request->user();

        $deviceToken = DeviceToken::query()->updateOrCreate([
            'token' => $request->string('token')->toString(),
        ], [
            'user_id' => $user->getKey(),
            'platform' => $request->string('platform')->toString(),
            'is_active' => true,
            'last_seen_at' => now(),
        ]);

        return $this->resource(
            new DeviceTokenResource($deviceToken),
            'Device token berhasil disimpan.',
        );
    }

    public function destroy(DeleteDeviceTokenRequest $request): JsonResponse
    {
        /** @var User $user */
        $user = $request->user();

        $deleted = $user->deviceTokens()
            ->where('token', $request->string('token')->toString())
            ->delete();

        if ($deleted === 0) {
            return $this->error('Device token tidak ditemukan.', 404);
        }

        return $this->success(null, 'Device token berhasil dihapus.');
    }
}
