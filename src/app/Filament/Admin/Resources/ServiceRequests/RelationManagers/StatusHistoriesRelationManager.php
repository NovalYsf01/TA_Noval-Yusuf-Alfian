<?php

declare(strict_types=1);

namespace App\Filament\Admin\Resources\ServiceRequests\RelationManagers;

use App\Enums\ServiceRequestStatus;
use Filament\Resources\RelationManagers\RelationManager;
use Filament\Schemas\Schema;
use Filament\Tables\Columns\TextColumn;
use Filament\Tables\Table;

final class StatusHistoriesRelationManager extends RelationManager
{
    protected static string $relationship = 'statusHistories';

    protected static ?string $title = 'Riwayat Status';

    public function form(Schema $schema): Schema
    {
        return $schema->components([]);
    }

    public function table(Table $table): Table
    {
        return $table
            ->columns([
                TextColumn::make('old_status')
                    ->label('Status sebelumnya')
                    ->formatStateUsing(fn (mixed $state): string => $state instanceof ServiceRequestStatus ? $state->label() : 'Pengajuan dibuat')
                    ->placeholder('Pengajuan dibuat')
                    ->badge(),
                TextColumn::make('new_status')
                    ->label('Status baru')
                    ->formatStateUsing(fn (ServiceRequestStatus $state): string => $state->label())
                    ->badge()
                    ->color(fn (ServiceRequestStatus $state): string => match ($state) {
                        ServiceRequestStatus::PENDING_VERIFICATION => 'warning',
                        ServiceRequestStatus::PROCESSING => 'info',
                        ServiceRequestStatus::REJECTED => 'danger',
                        ServiceRequestStatus::COMPLETED => 'success',
                    }),
                TextColumn::make('note')
                    ->label('Catatan')
                    ->placeholder('-')
                    ->wrap(),
                TextColumn::make('changedBy.name')
                    ->label('Diubah oleh')
                    ->placeholder('Sistem'),
                TextColumn::make('created_at')
                    ->label('Waktu')
                    ->dateTime('d M Y H:i:s')
                    ->sortable(),
            ])
            ->defaultSort('created_at', 'desc')
            ->paginated(false);
    }
}
