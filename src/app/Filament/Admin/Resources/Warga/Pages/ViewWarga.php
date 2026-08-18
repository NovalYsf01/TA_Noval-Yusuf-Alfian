<?php

declare(strict_types=1);

namespace App\Filament\Admin\Resources\Warga\Pages;

use App\Filament\Admin\Resources\Warga\WargaResource;
use Filament\Actions\EditAction;
use Filament\Resources\Pages\ViewRecord;

final class ViewWarga extends ViewRecord
{
    protected static string $resource = WargaResource::class;

    protected function getHeaderActions(): array
    {
        return [
            EditAction::make(),
        ];
    }
}
