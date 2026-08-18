<?php

declare(strict_types=1);

namespace App\Http\Requests\Api\V1;

use App\Enums\EmergencyType;
use Illuminate\Validation\Rule;

final class IndexEmergencyReportRequest extends ApiFormRequest
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
            'emergency_type' => ['nullable', Rule::enum(EmergencyType::class)],
            'per_page' => ['nullable', 'integer', 'min:1', 'max:50'],
        ];
    }
}
