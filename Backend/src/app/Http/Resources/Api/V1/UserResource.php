<?php

declare(strict_types=1);

namespace App\Http\Resources\Api\V1;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;
use Illuminate\Support\Facades\Storage;

final class UserResource extends JsonResource
{
    /**
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {
        return [
            'id' => $this->id,
            'name' => $this->name,
            'username' => $this->username,
            'house_code' => $this->house_code,
            'address' => $this->address,
            'phone' => $this->phone,
            'email' => $this->email,
            'avatar_url' => filled($this->avatar_url)
                ? Storage::disk('public')->url($this->avatar_url)
                : null,
            'is_active' => (bool) $this->is_active,
            'role' => 'warga',
        ];
    }
}
