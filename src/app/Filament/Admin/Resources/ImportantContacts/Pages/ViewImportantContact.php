<?php

declare(strict_types=1);

namespace App\Filament\Admin\Resources\ImportantContacts\Pages;

use App\Filament\Admin\Resources\ImportantContacts\ImportantContactResource;
use Filament\Actions\EditAction;
use Filament\Resources\Pages\ViewRecord;

final class ViewImportantContact extends ViewRecord
{
    protected static string $resource = ImportantContactResource::class;

    protected function getHeaderActions(): array
    {
        return [
            EditAction::make(),
        ];
    }
}
