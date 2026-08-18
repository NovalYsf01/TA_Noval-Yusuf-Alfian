<?php

declare(strict_types=1);

namespace App\Enums;

enum ServiceRequestStatus: string
{
    case PENDING_VERIFICATION = 'pending_verification';
    case PROCESSING = 'processing';
    case REJECTED = 'rejected';
    case COMPLETED = 'completed';

    public function label(): string
    {
        return match ($this) {
            self::PENDING_VERIFICATION => 'Menunggu Verifikasi',
            self::PROCESSING => 'Diproses',
            self::REJECTED => 'Ditolak',
            self::COMPLETED => 'Selesai',
        };
    }

    public function isTerminal(): bool
    {
        return in_array($this, [self::REJECTED, self::COMPLETED], true);
    }

    /**
     * @return list<self>
     */
    public function allowedTransitions(): array
    {
        return match ($this) {
            self::PENDING_VERIFICATION => [self::PROCESSING, self::REJECTED],
            self::PROCESSING => [self::COMPLETED],
            self::REJECTED, self::COMPLETED => [],
        };
    }

    public function canTransitionTo(self $nextStatus): bool
    {
        return in_array($nextStatus, $this->allowedTransitions(), true);
    }
}
