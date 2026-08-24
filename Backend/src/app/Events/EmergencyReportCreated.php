<?php

declare(strict_types=1);

namespace App\Events;

use App\Models\EmergencyReport;
use Illuminate\Foundation\Events\Dispatchable;
use Illuminate\Queue\SerializesModels;

final class EmergencyReportCreated
{
    use Dispatchable, SerializesModels;

    public function __construct(
        public EmergencyReport $emergencyReport,
    ) {}
}
