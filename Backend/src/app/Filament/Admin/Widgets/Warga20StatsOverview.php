<?php

declare(strict_types=1);

namespace App\Filament\Admin\Widgets;

use App\Enums\ServiceRequestStatus;
use App\Models\EmergencyReport;
use App\Models\ServiceRequest;
use App\Models\User;
use Filament\Widgets\StatsOverviewWidget as BaseWidget;
use Filament\Widgets\StatsOverviewWidget\Stat;

final class Warga20StatsOverview extends BaseWidget
{
    protected static ?int $sort = 1;

    protected int|string|array $columnSpan = 'full';

    protected ?string $pollingInterval = '30s';

    protected function getStats(): array
    {
        return [
            Stat::make('Warga Aktif', User::query()->warga()->active()->count())
                ->description('Akun mobile yang dapat login')
                ->descriptionIcon('heroicon-m-users')
                ->color('success'),
            Stat::make(
                'Menunggu Verifikasi',
                ServiceRequest::query()->withStatus(ServiceRequestStatus::PENDING_VERIFICATION)->count(),
            )
                ->description('Permohonan perlu tindakan')
                ->descriptionIcon('heroicon-m-clock')
                ->color('warning'),
            Stat::make(
                'Sedang Diproses',
                ServiceRequest::query()->withStatus(ServiceRequestStatus::PROCESSING)->count(),
            )
                ->description('Pelayanan berjalan')
                ->descriptionIcon('heroicon-m-arrow-path')
                ->color('info'),
            Stat::make(
                'Darurat Hari Ini',
                EmergencyReport::query()->whereDate('reported_at', today())->count(),
            )
                ->description('Segera cek dan tindak lanjuti')
                ->descriptionIcon('heroicon-m-exclamation-triangle')
                ->color('danger'),
        ];
    }
}
