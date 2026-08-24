<?php

declare(strict_types=1);

namespace App\Filament\Admin\Resources\RtInformations\Pages;

use App\Filament\Admin\Resources\RtInformations\RtInformationResource;
use Filament\Actions\EditAction;
use Filament\Resources\Pages\ViewRecord;

final class ViewRtInformation extends ViewRecord
{
    protected static string $resource = RtInformationResource::class;

    protected function getHeaderActions(): array
    {
        return [
            EditAction::make(),
        ];
    }
}
