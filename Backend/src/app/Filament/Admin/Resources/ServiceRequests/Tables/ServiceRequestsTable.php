<?php

declare(strict_types=1);

namespace App\Filament\Admin\Resources\ServiceRequests\Tables;

use App\Enums\ServiceRequestStatus;
use App\Filament\Admin\Resources\ServiceRequests\Actions\ServiceRequestActions;
use App\Models\ServiceRequest;
use Filament\Actions\ViewAction;
use Filament\Tables\Columns\TextColumn;
use Filament\Tables\Filters\SelectFilter;
use Filament\Tables\Table;

final class ServiceRequestsTable
{
    public static function configure(Table $table): Table
    {
        return $table
            ->columns([
                TextColumn::make('request_number')
                    ->label('Nomor')
                    ->copyable()
                    ->searchable()
                    ->sortable(),
                TextColumn::make('user.name')
                    ->label('Warga')
                    ->description(fn (ServiceRequest $record): string => $record->user->house_code ?? '-')
                    ->searchable()
                    ->sortable(),
                TextColumn::make('purpose')
                    ->label('Keperluan')
                    ->searchable()
                    ->wrap()
                    ->limit(55),
                TextColumn::make('status')
                    ->label('Status')
                    ->badge()
                    ->formatStateUsing(fn (ServiceRequestStatus $state): string => $state->label())
                    ->color(fn (ServiceRequestStatus $state): string => self::statusColor($state))
                    ->sortable(),
                TextColumn::make('submitted_at')
                    ->label('Diajukan')
                    ->dateTime('d M Y H:i')
                    ->sortable(),
                TextColumn::make('processedBy.name')
                    ->label('Admin')
                    ->placeholder('-')
                    ->toggleable(isToggledHiddenByDefault: true),
            ])
            ->filters([
                SelectFilter::make('status')
                    ->label('Status pelayanan')
                    ->options(self::statusOptions())
                    ->native(false),
            ])
            ->recordActions([
                ViewAction::make()->label(''),
                ServiceRequestActions::process()->label(''),
                ServiceRequestActions::reject()->label(''),
                ServiceRequestActions::complete()->label(''),
            ])
            ->defaultSort('submitted_at', 'desc')
            ->poll('30s')
            ->striped();
    }

    /**
     * @return array<string, string>
     */
    private static function statusOptions(): array
    {
        $options = [];

        foreach (ServiceRequestStatus::cases() as $status) {
            $options[$status->value] = $status->label();
        }

        return $options;
    }

    private static function statusColor(ServiceRequestStatus $status): string
    {
        return match ($status) {
            ServiceRequestStatus::PENDING_VERIFICATION => 'warning',
            ServiceRequestStatus::PROCESSING => 'info',
            ServiceRequestStatus::REJECTED => 'danger',
            ServiceRequestStatus::COMPLETED => 'success',
        };
    }
}
