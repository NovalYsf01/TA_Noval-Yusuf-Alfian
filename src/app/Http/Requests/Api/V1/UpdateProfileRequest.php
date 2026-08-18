<?php

declare(strict_types=1);

namespace App\Http\Requests\Api\V1;

use App\Models\User;
use Illuminate\Contracts\Validation\Validator;
use Illuminate\Support\Facades\Hash;
use Illuminate\Validation\Rule;
use Illuminate\Validation\Rules\Password;

final class UpdateProfileRequest extends ApiFormRequest
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
            'email' => [
                'sometimes',
                'required',
                'email:rfc',
                'max:255',
                Rule::unique('users', 'email')->ignore($this->user()?->getAuthIdentifier()),
            ],
            'phone' => [
                'sometimes',
                'nullable',
                'string',
                'max:30',
                'regex:/^[0-9+()\-\s]+$/',
            ],
            'current_password' => [
                'required_with:password',
                'string',
            ],
            'password' => [
                'sometimes',
                'required',
                'confirmed',
                Password::defaults(),
            ],
        ];
    }

    /**
     * @return array<string, string>
     */
    public function messages(): array
    {
        return [
            'email.email' => 'Format email tidak valid.',
            'email.unique' => 'Email sudah digunakan oleh akun lain.',
            'phone.regex' => 'Format nomor telepon tidak valid.',
            'current_password.required_with' => 'Password saat ini wajib diisi untuk mengganti password.',
            'password.confirmed' => 'Konfirmasi password baru tidak sesuai.',
        ];
    }

    public function withValidator(Validator $validator): void
    {
        $validator->after(function (Validator $validator): void {
            if (! $this->hasAny(['email', 'phone', 'password'])) {
                $validator->errors()->add('profile', 'Kirim setidaknya satu data profil yang ingin diperbarui.');
            }

            $user = $this->user();

            if (
                $this->filled('password')
                && $this->filled('current_password')
                && (
                    ! $user instanceof User
                    || ! Hash::check((string) $this->input('current_password'), $user->getAuthPassword())
                )
            ) {
                $validator->errors()->add('current_password', 'Password saat ini tidak sesuai.');
            }
        });
    }

    protected function prepareForValidation(): void
    {
        $data = [];

        if ($this->has('email')) {
            $data['email'] = mb_strtolower(trim((string) $this->input('email')));
        }

        if ($this->has('phone')) {
            $phone = trim((string) $this->input('phone'));
            $data['phone'] = $phone !== '' ? $phone : null;
        }

        $this->merge($data);
    }
}
