<?php

declare(strict_types=1);

namespace App\Enums;

enum EmergencyType: string
{
    case FIRE = 'fire';
    case ILLNESS_OR_ACCIDENT = 'illness_or_accident';
    case THEFT = 'theft';
    case CRIME = 'crime';
    case DEATH = 'death';
    case OTHER = 'other';

    public function label(): string
    {
        return match ($this) {
            self::FIRE => 'Kebakaran',
            self::ILLNESS_OR_ACCIDENT => 'Sakit/Kecelakaan',
            self::THEFT => 'Pencurian',
            self::CRIME => 'Tindak Kejahatan',
            self::DEATH => 'Kematian',
            self::OTHER => 'Keadaan Darurat Lainnya',
        };
    }
}
