<?php

declare(strict_types=1);

namespace App\Http\Resources\Api\V1;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;
use Illuminate\Support\Facades\Storage;

final class EmergencyReportResource extends JsonResource
{
    /**
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {
        return [
            'id' => $this->id,

            'emergency_type' => [
                'code' => $this->emergency_type->value,
                'label' => $this->emergency_type->label(),
            ],

            'description' => $this->description,

            'status' => [
                'code' => $this->status?->value ?? 'waiting',
                'label' => $this->status?->label()
                    ?? 'Menunggu Penanganan',
            ],

            'feedback' => $this->feedback,

            'evidence_photo_path' =>
                $this->evidence_photo_path,

            'evidence_photo_url' =>
                filled($this->evidence_photo_path)
                    ? Storage::disk('public')->url(
                        $this->evidence_photo_path
                    )
                    : null,

            'handled_by' => $this->handler
                ? [
                    'id' => $this->handler->id,
                    'name' => $this->handler->name,
                ]
                : null,

            'handled_at' =>
                $this->handled_at?->toIso8601String(),

            'resolved_at' =>
                $this->resolved_at?->toIso8601String(),

            'archived_at' =>
                $this->archived_at?->toIso8601String(),

            'reported_at' =>
                $this->reported_at?->toIso8601String(),

            'created_at' =>
                $this->created_at?->toIso8601String(),

            'updated_at' =>
                $this->updated_at?->toIso8601String(),
        ];
    }
}
