<?php

declare(strict_types=1);

namespace App\Filament\Admin\Resources\Warga\Pages;

use App\Filament\Admin\Resources\Warga\WargaResource;
use Filament\Resources\Pages\CreateRecord;

final class CreateWarga extends CreateRecord
{
    protected static string $resource = WargaResource::class;

    protected function afterCreate(): void
    {
        $this->record->syncRoles(['warga']);
    }
}
