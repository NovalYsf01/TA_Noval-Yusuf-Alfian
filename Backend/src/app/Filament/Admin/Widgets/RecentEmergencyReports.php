<?php

declare(strict_types=1);

namespace App\Filament\Admin\Widgets;

use App\Enums\EmergencyType;
use App\Filament\Admin\Resources\EmergencyReports\EmergencyReportResource;
use App\Models\EmergencyReport;
use Filament\Tables\Columns\TextColumn;
use Filament\Tables\Table;
use Filament\Widgets\TableWidget as BaseWidget;

final class RecentEmergencyReports extends BaseWidget
{
    protected static ?int $sort = 3;

    protected int|string|array $columnSpan = 1;

    public function table(Table $table): Table
    {
        return $table
            ->heading('Laporan Darurat Terbaru')
            ->description('Lima laporan darurat terakhir. Tidak memerlukan approval.')
            ->query(
                EmergencyReport::query()
                    ->with('user')
                    ->latest('reported_at')
                    ->limit(5),
            )
            ->columns([
                TextColumn::make('emergency_type')
                    ->label('Jenis')
                    ->formatStateUsing(fn (EmergencyType $state): string => $state->label())
                    ->badge()
                    ->color('danger'),
                TextColumn::make('user.name')
                    ->label('Pelapor')
                    ->description(fn (EmergencyReport $record): string => $record->user->house_code ?? '-'),
                TextColumn::make('description')
                    ->label('Keterangan')
                    ->limit(40),
                TextColumn::make('reported_at')
                    ->label('Waktu')
                    ->since(),
            ])
            ->recordUrl(fn (EmergencyReport $record): string => EmergencyReportResource::getUrl('view', ['record' => $record]))
            ->paginated(false)
            ->poll('15s');
    }
}
