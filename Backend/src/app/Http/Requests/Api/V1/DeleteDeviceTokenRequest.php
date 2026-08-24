<?php

declare(strict_types=1);

namespace App\Http\Requests\Api\V1;

final class DeleteDeviceTokenRequest extends ApiFormRequest
{
    public function authorize(): bool
    {
        return $this->user() !== null;
    }

    /**
     * @return array<string, list<string>>
     */
    public function rules(): array
    {
        return [
            'token' => ['required', 'string', 'max:512'],
        ];
    }

    /**
     * @return array<string, string>
     */
    public function messages(): array
    {
        return [
            'token.required' => 'Device token wajib diisi.',
        ];
    }

    protected function prepareForValidation(): void
    {
        $this->merge([
            'token' => mb_trim((string) $this->input('token')),
        ]);
    }
}
