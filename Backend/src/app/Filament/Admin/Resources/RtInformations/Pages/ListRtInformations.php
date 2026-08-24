<?php

declare(strict_types=1);

namespace App\Filament\Admin\Resources\RtInformations\Pages;

use App\Filament\Admin\Resources\RtInformations\RtInformationResource;
use Filament\Actions\CreateAction;
use Filament\Resources\Pages\ListRecords;

final class ListRtInformations extends ListRecords
{
    protected static string $resource = RtInformationResource::class;

    protected function getHeaderActions(): array
    {
        return [
            CreateAction::make()->label('Buat informasi'),
        ];
    }
}
