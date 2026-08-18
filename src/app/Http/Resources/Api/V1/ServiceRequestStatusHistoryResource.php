<?php

declare(strict_types=1);

namespace App\Http\Resources\Api\V1;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

final class ServiceRequestStatusHistoryResource extends JsonResource
{
    /**
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {
        return [
            'id' => $this->id,
            'old_status' => $this->old_status === null ? null : [
                'code' => $this->old_status->value,
                'label' => $this->old_status->label(),
            ],
            'new_status' => [
                'code' => $this->new_status->value,
                'label' => $this->new_status->label(),
            ],
            'note' => $this->note,
            'changed_by' => $this->relationLoaded('changedBy') && $this->changedBy !== null
                ? [
                    'id' => $this->changedBy->id,
                    'name' => $this->changedBy->name,
                ]
                : null,
            'created_at' => $this->created_at?->toIso8601String(),
        ];
    }
}
