<?php

declare(strict_types=1);

namespace App\Filament\Admin\Resources\RtInformations\Pages;

use App\Filament\Admin\Resources\RtInformations\RtInformationResource;
use Filament\Resources\Pages\CreateRecord;

final class CreateRtInformation extends CreateRecord
{
    protected static string $resource = RtInformationResource::class;

    protected function mutateFormDataBeforeCreate(array $data): array
    {
        $data['created_by'] = auth()->id();

        return $data;
    }
}
