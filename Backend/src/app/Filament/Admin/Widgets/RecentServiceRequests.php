<?php

declare(strict_types=1);

namespace App\Filament\Admin\Widgets;

use App\Enums\ServiceRequestStatus;
use App\Filament\Admin\Resources\ServiceRequests\ServiceRequestResource;
use App\Models\ServiceRequest;
use Filament\Tables\Columns\TextColumn;
use Filament\Tables\Table;
use Filament\Widgets\TableWidget as BaseWidget;

final class RecentServiceRequests extends BaseWidget
{
    protected static ?int $sort = 2;

    protected int|string|array $columnSpan = 1;

    public function table(Table $table): Table
    {
        return $table
            ->heading('Pelayanan Terbaru')
            ->description('Lima permohonan pelayanan terakhir dari warga.')
            ->query(
                ServiceRequest::query()
                    ->with('user')
                    ->latest('submitted_at')
                    ->limit(5),
            )
            ->columns([
                TextColumn::make('request_number')
                    ->label('Nomor')
                    ->searchable(),
                TextColumn::make('user.name')
                    ->label('Warga')
                    ->description(fn (ServiceRequest $record): string => $record->user->house_code ?? '-'),
                TextColumn::make('status')
                    ->label('Status')
                    ->badge()
                    ->formatStateUsing(fn (ServiceRequestStatus $state): string => $state->label())
                    ->color(fn (ServiceRequestStatus $state): string => match ($state) {
                        ServiceRequestStatus::PENDING_VERIFICATION => 'warning',
                        ServiceRequestStatus::PROCESSING => 'info',
                        ServiceRequestStatus::REJECTED => 'danger',
                        ServiceRequestStatus::COMPLETED => 'success',
                    }),
                TextColumn::make('submitted_at')
                    ->label('Waktu')
                    ->since(),
            ])
            ->recordUrl(fn (ServiceRequest $record): string => ServiceRequestResource::getUrl('view', ['record' => $record]))
            ->paginated(false)
            ->poll('30s');
    }
}
