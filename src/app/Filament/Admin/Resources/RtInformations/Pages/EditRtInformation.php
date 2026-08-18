<?php

declare(strict_types=1);

namespace App\Filament\Admin\Resources\RtInformations\Pages;

use App\Filament\Admin\Resources\RtInformations\RtInformationResource;
use Filament\Actions\DeleteAction;
use Filament\Actions\ViewAction;
use Filament\Resources\Pages\EditRecord;

final class EditRtInformation extends EditRecord
{
    protected static string $resource = RtInformationResource::class;

    protected function getHeaderActions(): array
    {
        return [
            ViewAction::make(),
            DeleteAction::make(),
        ];
    }
}
