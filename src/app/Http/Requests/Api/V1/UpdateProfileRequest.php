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
            'name' => [
                'sometimes',
                'required',
                'string',
                'max:150',
            ],

            'username' => [
                'sometimes',
                'required',
                'string',
                'min:4',
                'max:100',
                'alpha_dash',
                Rule::unique('users', 'username')
                    ->ignore(
                        $this->user()?->getAuthIdentifier()
                    ),
            ],

            'email' => [
                'sometimes',
                'required',
                'email:rfc',
                'max:255',
                Rule::unique('users', 'email')
                    ->ignore(
                        $this->user()?->getAuthIdentifier()
                    ),
            ],

            'phone' => [
                'sometimes',
                'required',
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
                Password::min(8),
            ],
        ];
    }

    /**
     * @return array<string, string>
     */
    public function messages(): array
    {
        return [
            'name.required' =>
                'Nama lengkap wajib diisi.',

            'username.required' =>
                'Username wajib diisi.',

            'username.min' =>
                'Username minimal 4 karakter.',

            'username.alpha_dash' =>
                'Username hanya boleh berisi huruf, angka, tanda hubung, dan underscore.',

            'username.unique' =>
                'Username sudah digunakan oleh akun lain.',

            'email.required' =>
                'Email wajib diisi.',

            'email.email' =>
                'Format email tidak valid.',

            'email.unique' =>
                'Email sudah digunakan oleh akun lain.',

            'phone.required' =>
                'Nomor telepon wajib diisi.',

            'phone.regex' =>
                'Format nomor telepon tidak valid.',

            'current_password.required_with' =>
                'Password saat ini wajib diisi untuk mengganti password.',

            'password.min' =>
                'Password baru minimal 8 karakter.',

            'password.confirmed' =>
                'Konfirmasi password baru tidak sesuai.',
        ];
    }

    public function withValidator(
        Validator $validator
    ): void {
        $validator->after(
            function (Validator $validator): void {
                if (
                    ! $this->hasAny([
                        'name',
                        'username',
                        'email',
                        'phone',
                        'password',
                    ])
                ) {
                    $validator
                        ->errors()
                        ->add(
                            'profile',
                            'Kirim setidaknya satu data profil yang ingin diperbarui.'
                        );
                }

                $user = $this->user();

                if (
                    $this->filled('password')
                    && $this->filled(
                        'current_password'
                    )
                    && (
                        ! $user instanceof User
                        || ! Hash::check(
                            (string) $this->input(
                                'current_password'
                            ),
                            $user->getAuthPassword()
                        )
                    )
                ) {
                    $validator
                        ->errors()
                        ->add(
                            'current_password',
                            'Password saat ini tidak sesuai.'
                        );
                }
            }
        );
    }

    protected function prepareForValidation(): void
    {
        $data = [];

        if ($this->has('name')) {
            $data['name'] = trim(
                (string) $this->input('name')
            );
        }

        if ($this->has('username')) {
            $data['username'] = mb_strtolower(
                trim(
                    (string) $this->input(
                        'username'
                    )
                )
            );
        }

        if ($this->has('email')) {
            $data['email'] = mb_strtolower(
                trim(
                    (string) $this->input(
                        'email'
                    )
                )
            );
        }

        if ($this->has('phone')) {
            $data['phone'] = trim(
                (string) $this->input('phone')
            );
        }

        $this->merge($data);
    }
}
