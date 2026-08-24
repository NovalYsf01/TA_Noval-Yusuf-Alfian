<?php

declare(strict_types=1);

namespace App\Http\Requests\Api\V1;

use App\Enums\ServiceRequestStatus;
use Illuminate\Validation\Rule;

final class IndexServiceRequestRequest extends ApiFormRequest
{
    public function authorize(): bool
    {
        return $this->user() !== null;
    }

    /**
     * @return array<string, list<mixed>>
     */
    public function rules(): array
    {
        return [
            'status' => ['nullable', Rule::enum(ServiceRequestStatus::class)],
            'per_page' => ['nullable', 'integer', 'min:1', 'max:50'],
        ];
    }
}
