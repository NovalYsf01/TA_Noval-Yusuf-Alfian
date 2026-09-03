<?php

declare(strict_types=1);

namespace App\Http\Requests\Api\V1\Auth;

use App\Http\Requests\Api\V1\ApiFormRequest;
use Illuminate\Validation\Rules\Password;

final class RegisterRequest extends ApiFormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    /**
     * @return array<string, mixed>
     */
    public function rules(): array
    {
        return [
            'name' => [
                'required',
                'string',
                'max:150',
            ],

            'email' => [
                'required',
                'email',
                'max:150',
                'unique:users,email',
            ],

            'username' => [
                'required',
                'string',
                'min:4',
                'max:100',
                'alpha_dash',
                'unique:users,username',
            ],

            'house_code' => [
                'required',
                'string',
                'max:50',
                'unique:users,house_code',
            ],

            'address' => [
                'required',
                'string',
                'max:500',
            ],

            'phone' => [
                'required',
                'string',
                'max:30',
            ],

            'password' => [
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

            'email.required' =>
                'Email wajib diisi.',

            'email.email' =>
                'Format email tidak valid.',

            'email.unique' =>
                'Email sudah digunakan.',

            'username.required' =>
                'Username wajib diisi.',

            'username.unique' =>
                'Username sudah digunakan.',

            'username.alpha_dash' =>
                'Username hanya boleh berisi huruf, angka, tanda hubung, dan underscore.',

            'house_code.required' =>
                'Kode rumah wajib diisi.',

            'house_code.unique' =>
                'Rumah tersebut sudah memiliki akun.',

            'address.required' =>
                'Alamat wajib diisi.',

            'phone.required' =>
                'Nomor telepon wajib diisi.',

            'password.required' =>
                'Password wajib diisi.',

            'password.confirmed' =>
                'Konfirmasi password tidak sesuai.',
        ];
    }

    protected function prepareForValidation(): void
    {
        $this->merge([
            'name' => trim((string) $this->input('name')),

            'email' => mb_strtolower(
                trim((string) $this->input('email'))
            ),

            'username' => mb_strtolower(
                trim((string) $this->input('username'))
            ),

            'house_code' => mb_strtoupper(
                trim((string) $this->input('house_code'))
            ),

            'address' => trim(
                (string) $this->input('address')
            ),

            'phone' => trim(
                (string) $this->input('phone')
            ),
        ]);
    }
}
