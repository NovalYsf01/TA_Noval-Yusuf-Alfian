<?php

declare(strict_types=1);

namespace App\Filament\Admin\Resources\ServiceRequests\Pages;

use App\Filament\Admin\Resources\ServiceRequests\Actions\ServiceRequestActions;
use App\Filament\Admin\Resources\ServiceRequests\ServiceRequestResource;
use Filament\Resources\Pages\ViewRecord;

final class ViewServiceRequest extends ViewRecord
{
    protected static string $resource = ServiceRequestResource::class;

    protected function getHeaderActions(): array
    {
        return [
            ServiceRequestActions::downloadAttachment(),
            ServiceRequestActions::downloadResult(),
            ServiceRequestActions::process(),
            ServiceRequestActions::reject(),
            ServiceRequestActions::complete(),
        ];
    }
}
