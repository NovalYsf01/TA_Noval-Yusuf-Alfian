<?php

declare(strict_types=1);

namespace App\Http\Requests\Api\V1;

use Illuminate\Validation\Rule;

final class StoreDeviceTokenRequest extends ApiFormRequest
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
            'token' => ['required', 'string', 'max:512'],
            'platform' => ['required', Rule::in(['android', 'ios'])],
        ];
    }

    /**
     * @return array<string, string>
     */
    public function messages(): array
    {
        return [
            'token.required' => 'Device token wajib diisi.',
            'token.max' => 'Device token terlalu panjang.',
            'platform.in' => 'Platform hanya boleh android atau ios.',
        ];
    }

    protected function prepareForValidation(): void
    {
        $this->merge([
            'token' => mb_trim((string) $this->input('token')),
            'platform' => mb_strtolower(mb_trim((string) $this->input('platform', 'android'))),
        ]);
    }
}
