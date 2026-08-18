<?php

declare(strict_types=1);

namespace App\Filament\Admin\Resources\ImportantContacts\Pages;

use App\Filament\Admin\Resources\ImportantContacts\ImportantContactResource;
use Filament\Actions\DeleteAction;
use Filament\Actions\ViewAction;
use Filament\Resources\Pages\EditRecord;

final class EditImportantContact extends EditRecord
{
    protected static string $resource = ImportantContactResource::class;

    protected function getHeaderActions(): array
    {
        return [
            ViewAction::make(),
            DeleteAction::make(),
        ];
    }
}
