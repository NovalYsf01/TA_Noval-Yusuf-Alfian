<?php

declare(strict_types=1);

namespace App\Filament\Admin\Resources\EmergencyReports\Pages;

use App\Filament\Admin\Resources\EmergencyReports\EmergencyReportResource;
use Filament\Resources\Pages\ViewRecord;

final class ViewEmergencyReport extends ViewRecord
{
    protected static string $resource = EmergencyReportResource::class;
}
