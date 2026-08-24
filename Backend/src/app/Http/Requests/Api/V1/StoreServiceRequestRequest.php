<?php

declare(strict_types=1);

namespace App\Http\Requests\Api\V1;

final class StoreServiceRequestRequest extends ApiFormRequest
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
            'purpose' => ['required', 'string', 'max:255'],
            'description' => ['nullable', 'string', 'max:2000'],
            'attachment' => ['nullable', 'file', 'image', 'mimes:jpg,jpeg,png', 'max:5120'],
        ];
    }

    /**
     * @return array<string, string>
     */
    public function messages(): array
    {
        return [
            'purpose.required' => 'Keperluan pelayanan wajib diisi.',
            'purpose.max' => 'Keperluan pelayanan maksimal 255 karakter.',
            'description.max' => 'Keterangan maksimal 2.000 karakter.',
            'attachment.image' => 'Lampiran harus berupa gambar.',
            'attachment.mimes' => 'Lampiran hanya boleh berformat JPG, JPEG, atau PNG.',
            'attachment.max' => 'Ukuran lampiran maksimal 5 MB.',
        ];
    }

    protected function prepareForValidation(): void
    {
        $this->merge([
            'purpose' => mb_trim((string) $this->input('purpose')),
            'description' => $this->filled('description')
                ? mb_trim((string) $this->input('description'))
                : null,
        ]);
    }
}
