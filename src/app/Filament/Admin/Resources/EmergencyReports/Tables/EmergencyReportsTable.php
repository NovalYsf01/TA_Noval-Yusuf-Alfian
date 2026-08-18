<?php

declare(strict_types=1);

namespace App\Filament\Admin\Resources\EmergencyReports\Tables;

use App\Enums\EmergencyType;
use App\Models\EmergencyReport;
use Filament\Actions\ViewAction;
use Filament\Tables\Columns\TextColumn;
use Filament\Tables\Filters\Filter;
use Filament\Tables\Filters\SelectFilter;
use Filament\Tables\Table;
use Illuminate\Database\Eloquent\Builder;

final class EmergencyReportsTable
{
    public static function configure(Table $table): Table
    {
        return $table
            ->columns([
                TextColumn::make('emergency_type')
                    ->label('Jenis darurat')
                    ->formatStateUsing(fn (EmergencyType $state): string => $state->label())
                    ->badge()
                    ->color('danger')
                    ->sortable(),
                TextColumn::make('user.name')
                    ->label('Pelapor')
                    ->description(fn (EmergencyReport $record): string => $record->user->house_code ?? '-')
                    ->searchable()
                    ->sortable(),
                TextColumn::make('user.phone')
                    ->label('Telepon')
                    ->copyable()
                    ->placeholder('-'),
                TextColumn::make('description')
                    ->label('Keterangan')
                    ->limit(70)
                    ->wrap()
                    ->searchable(),
                TextColumn::make('reported_at')
                    ->label('Dilaporkan')
                    ->dateTime('d M Y H:i:s')
                    ->sortable(),
            ])
            ->filters([
                SelectFilter::make('emergency_type')
                    ->label('Jenis darurat')
                    ->options(self::typeOptions())
                    ->native(false),
                Filter::make('today')
                    ->label('Hari ini')
                    ->query(fn (Builder $query): Builder => $query->whereDate('reported_at', today())),
            ])
            ->recordActions([
                ViewAction::make()->label(''),
            ])
            ->defaultSort('reported_at', 'desc')
            ->poll('15s')
            ->striped();
    }

    /**
     * @return array<string, string>
     */
    private static function typeOptions(): array
    {
        $options = [];

        foreach (EmergencyType::cases() as $type) {
            $options[$type->value] = $type->label();
        }

        return $options;
    }
}
