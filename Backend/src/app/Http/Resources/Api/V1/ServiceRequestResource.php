<?php

declare(strict_types=1);

namespace App\Http\Resources\Api\V1;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

final class ServiceRequestResource extends JsonResource
{
    /**
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {
        return [
            'id' => $this->id,
            'request_number' => $this->request_number,
            'purpose' => $this->purpose,
            'description' => $this->description,
            'status' => [
                'code' => $this->status->value,
                'label' => $this->status->label(),
            ],
            'admin_note' => $this->admin_note,
            'has_attachment' => filled($this->attachment_path),
            'attachment_download_url' => filled($this->attachment_path)
                ? route('api.v1.service-requests.attachment', ['serviceRequest' => $this->id])
                : null,
            'has_result_document' => filled($this->result_document_path),
            'result_document_download_url' => filled($this->result_document_path)
                ? route('api.v1.service-requests.result-document', ['serviceRequest' => $this->id])
                : null,
            'submitted_at' => $this->submitted_at?->toIso8601String(),
            'processed_at' => $this->processed_at?->toIso8601String(),
            'rejected_at' => $this->rejected_at?->toIso8601String(),
            'completed_at' => $this->completed_at?->toIso8601String(),
            'status_history' => ServiceRequestStatusHistoryResource::collection(
                $this->whenLoaded('statusHistories'),
            ),
            'created_at' => $this->created_at?->toIso8601String(),
            'updated_at' => $this->updated_at?->toIso8601String(),
        ];
    }
}
