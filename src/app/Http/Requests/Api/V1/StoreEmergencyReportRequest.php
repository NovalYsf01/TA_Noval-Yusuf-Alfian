<?php

declare(strict_types=1);

namespace App\Http\Requests\Api\V1;

use App\Enums\EmergencyType;
use Illuminate\Validation\Rule;

final class StoreEmergencyReportRequest extends ApiFormRequest
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
            'emergency_type' => ['required', Rule::enum(EmergencyType::class)],
            'description' => ['required', 'string', 'min:5', 'max:2000'],
        ];
    }

    /**
     * @return array<string, string>
     */
    public function messages(): array
    {
        return [
            'emergency_type.required' => 'Jenis keadaan darurat wajib dipilih.',
            'emergency_type.enum' => 'Jenis keadaan darurat tidak valid.',
            'description.required' => 'Keterangan keadaan darurat wajib diisi.',
            'description.min' => 'Keterangan keadaan darurat minimal 5 karakter.',
            'description.max' => 'Keterangan keadaan darurat maksimal 2.000 karakter.',
        ];
    }

    protected function prepareForValidation(): void
    {
        $this->merge([
            'description' => trim((string) $this->input('description')),
        ]);
    }
}
