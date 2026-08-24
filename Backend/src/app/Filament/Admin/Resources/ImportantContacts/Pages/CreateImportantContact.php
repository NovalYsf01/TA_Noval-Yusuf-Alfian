<?php

declare(strict_types=1);

namespace App\Filament\Admin\Resources\ImportantContacts\Pages;

use App\Filament\Admin\Resources\ImportantContacts\ImportantContactResource;
use Filament\Resources\Pages\CreateRecord;

final class CreateImportantContact extends CreateRecord
{
    protected static string $resource = ImportantContactResource::class;
}
