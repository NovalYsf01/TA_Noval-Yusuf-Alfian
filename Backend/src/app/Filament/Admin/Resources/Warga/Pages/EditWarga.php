<?php

declare(strict_types=1);

namespace App\Filament\Admin\Resources\Warga\Pages;

use App\Filament\Admin\Resources\Warga\WargaResource;
use Filament\Actions\ViewAction;
use Filament\Resources\Pages\EditRecord;

final class EditWarga extends EditRecord
{
    protected static string $resource = WargaResource::class;

    protected function afterSave(): void
    {
        $this->record->syncRoles(['warga']);
    }

    protected function getHeaderActions(): array
    {
        return [
            ViewAction::make(),
        ];
    }
}
