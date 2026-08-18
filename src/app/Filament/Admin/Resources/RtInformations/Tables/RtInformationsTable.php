<?php

declare(strict_types=1);

namespace App\Filament\Admin\Resources\RtInformations\Tables;

use App\Models\RtInformation;
use Filament\Actions\DeleteAction;
use Filament\Actions\EditAction;
use Filament\Actions\ViewAction;
use Filament\Tables\Columns\ImageColumn;
use Filament\Tables\Columns\TextColumn;
use Filament\Tables\Filters\Filter;
use Filament\Tables\Table;
use Illuminate\Database\Eloquent\Builder;

final class RtInformationsTable
{
    public static function configure(Table $table): Table
    {
        return $table
            ->columns([
                ImageColumn::make('image_path')
                    ->label('Gambar')
                    ->disk('public')
                    ->visibility('public')
                    ->square()
                    ->toggleable(),
                TextColumn::make('title')
                    ->label('Judul')
                    ->searchable()
                    ->sortable()
                    ->wrap(),
                TextColumn::make('publication_status')
                    ->label('Status')
                    ->state(fn (RtInformation $record): string => match (true) {
                        $record->published_at === null => 'Draf',
                        $record->isPublished() => 'Terbit',
                        default => 'Terjadwal',
                    })
                    ->badge()
                    ->color(fn (string $state): string => match ($state) {
                        'Terbit' => 'success',
                        'Terjadwal' => 'info',
                        default => 'gray',
                    }),
                TextColumn::make('published_at')
                    ->label('Waktu terbit')
                    ->dateTime('d M Y H:i')
                    ->placeholder('-')
                    ->sortable(),
                TextColumn::make('creator.name')
                    ->label('Pembuat')
                    ->placeholder('-')
                    ->toggleable(),
                TextColumn::make('updated_at')
                    ->label('Terakhir diubah')
                    ->since()
                    ->sortable()
                    ->toggleable(isToggledHiddenByDefault: true),
            ])
            ->filters([
                Filter::make('published')
                    ->label('Sudah terbit')
                    ->query(fn (Builder $query): Builder => $query->published()),
                Filter::make('draft')
                    ->label('Draf')
                    ->query(fn (Builder $query): Builder => $query->whereNull('published_at')),
                Filter::make('scheduled')
                    ->label('Terjadwal')
                    ->query(fn (Builder $query): Builder => $query
                        ->whereNotNull('published_at')
                        ->where('published_at', '>', now())),
            ])
            ->recordActions([
                ViewAction::make()->label(''),
                EditAction::make()->label(''),
                DeleteAction::make()->label(''),
            ])
            ->defaultSort('created_at', 'desc')
            ->striped();
    }
}
