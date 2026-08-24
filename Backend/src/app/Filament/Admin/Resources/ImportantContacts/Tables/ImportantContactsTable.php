<?php

declare(strict_types=1);

namespace App\Filament\Admin\Resources\ImportantContacts\Tables;

use Filament\Actions\DeleteAction;
use Filament\Actions\EditAction;
use Filament\Actions\ViewAction;
use Filament\Tables\Columns\IconColumn;
use Filament\Tables\Columns\TextColumn;
use Filament\Tables\Filters\SelectFilter;
use Filament\Tables\Filters\TernaryFilter;
use Filament\Tables\Table;

final class ImportantContactsTable
{
    public static function configure(Table $table): Table
    {
        return $table
            ->columns([
                TextColumn::make('name')
                    ->label('Nama kontak')
                    ->searchable()
                    ->sortable(),
                TextColumn::make('category')
                    ->label('Kategori')
                    ->badge()
                    ->searchable()
                    ->sortable(),
                TextColumn::make('phone_number')
                    ->label('Nomor telepon')
                    ->copyable()
                    ->searchable(),
                TextColumn::make('description')
                    ->label('Keterangan')
                    ->limit(60)
                    ->wrap()
                    ->toggleable(),
                IconColumn::make('is_active')
                    ->label('Aktif')
                    ->boolean()
                    ->sortable(),
                TextColumn::make('updated_at')
                    ->label('Terakhir diubah')
                    ->since()
                    ->sortable()
                    ->toggleable(isToggledHiddenByDefault: true),
            ])
            ->filters([
                SelectFilter::make('category')
                    ->label('Kategori')
                    ->options(fn (): array => \App\Models\ImportantContact::query()
                        ->orderBy('category')
                        ->pluck('category', 'category')
                        ->all())
                    ->searchable()
                    ->native(false),
                TernaryFilter::make('is_active')
                    ->label('Status')
                    ->trueLabel('Aktif')
                    ->falseLabel('Nonaktif')
                    ->native(false),
            ])
            ->recordActions([
                ViewAction::make()->label(''),
                EditAction::make()->label(''),
                DeleteAction::make()->label(''),
            ])
            ->defaultSort('category')
            ->striped();
    }
}
