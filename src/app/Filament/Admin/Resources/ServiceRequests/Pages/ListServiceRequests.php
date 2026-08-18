<?php

declare(strict_types=1);

namespace App\Filament\Admin\Resources\ServiceRequests\Pages;

use App\Filament\Admin\Resources\ServiceRequests\ServiceRequestResource;
use Filament\Resources\Pages\ListRecords;

final class ListServiceRequests extends ListRecords
{
    protected static string $resource = ServiceRequestResource::class;
}
