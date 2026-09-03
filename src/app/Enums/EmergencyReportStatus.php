<?php

declare(strict_types=1);

namespace App\Enums;

enum EmergencyReportStatus: string
{
    case WAITING = 'waiting';

    case IN_PROGRESS = 'in_progress';

    case RESOLVED = 'resolved';

    public function label(): string
    {
        return match ($this) {
            self::WAITING =>
                'Menunggu Penanganan',

            self::IN_PROGRESS =>
                'Sedang Ditangani',

            self::RESOLVED =>
                'Selesai',
        };
    }

    public function color(): string
    {
        return match ($this) {
            self::WAITING =>
                'danger',

            self::IN_PROGRESS =>
                'warning',

            self::RESOLVED =>
                'success',
        };
    }
}
