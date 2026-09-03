<?php

declare(strict_types=1);

namespace App\Http\Requests\Api\V1;

final class UpdateAvatarRequest extends ApiFormRequest
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
            'avatar' => [
                'required',
                'image',
                'mimes:jpg,jpeg,png,webp',
                'max:2048',
            ],
        ];
    }

    /**
     * @return array<string, string>
     */
    public function messages(): array
    {
        return [
            'avatar.required' =>
                'Foto profil wajib dipilih.',

            'avatar.image' =>
                'File harus berupa gambar.',

            'avatar.mimes' =>
                'Foto profil harus berformat JPG, JPEG, PNG, atau WEBP.',

            'avatar.max' =>
                'Ukuran foto profil maksimal 2 MB.',
        ];
    }
}
