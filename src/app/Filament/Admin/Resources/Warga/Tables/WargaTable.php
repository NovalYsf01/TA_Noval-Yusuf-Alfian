<?php

declare(strict_types=1);

namespace App\Filament\Admin\Resources\Warga\Tables;

use App\Models\User;
use Filament\Actions\Action;
use Filament\Actions\EditAction;
use Filament\Actions\ViewAction;
use Filament\Forms\Components\TextInput;
use Filament\Notifications\Notification;
use Filament\Tables\Columns\IconColumn;
use Filament\Tables\Columns\ImageColumn;
use Filament\Tables\Columns\TextColumn;
use Filament\Tables\Filters\TernaryFilter;
use Filament\Tables\Table;

final class WargaTable
{
    public static function configure(Table $table): Table
    {
        return $table
            ->columns([
                ImageColumn::make('avatar_url')
                    ->label('Foto')
                    ->disk('public')
                    ->visibility('public')
                    ->circular()
                    ->defaultImageUrl('https://www.gravatar.com/avatar/64e1b8d34f425d19e1ee2ea7236d3028?d=mp&r=g&s=250'),
                TextColumn::make('name')
                    ->label('Nama warga')
                    ->description(fn (User $record): string => $record->username ?? '-')
                    ->searchable(['name', 'username'])
                    ->sortable(),
                TextColumn::make('house_code')
                    ->label('Rumah')
                    ->badge()
                    ->searchable()
                    ->sortable(),
                TextColumn::make('phone')
                    ->label('Telepon')
                    ->copyable()
                    ->placeholder('-')
                    ->searchable(),
                TextColumn::make('email')
                    ->label('Email')
                    ->copyable()
                    ->searchable()
                    ->toggleable(),
                IconColumn::make('is_active')
                    ->label('Aktif')
                    ->boolean()
                    ->sortable(),
                TextColumn::make('created_at')
                    ->label('Dibuat')
                    ->dateTime('d M Y H:i')
                    ->sortable()
                    ->toggleable(isToggledHiddenByDefault: true),
            ])
            ->filters([
                TernaryFilter::make('is_active')
                    ->label('Status akun')
                    ->trueLabel('Aktif')
                    ->falseLabel('Nonaktif')
                    ->native(false),
            ])
            ->recordActions([
                ViewAction::make()->label(''),
                EditAction::make()->label(''),
                Action::make('activate')
                    ->label('Aktifkan')
                    ->icon('heroicon-o-lock-open')
                    ->color('success')
                    ->requiresConfirmation()
                    ->visible(fn (User $record): bool => ! $record->is_active)
                    ->action(function (User $record): void {
                        $record->update(['is_active' => true]);

                        Notification::make()
                            ->success()
                            ->title('Akun warga diaktifkan')
                            ->body("{$record->name} sekarang dapat login ke aplikasi mobile.")
                            ->send();
                    }),
                Action::make('deactivate')
                    ->label('Nonaktifkan')
                    ->icon('heroicon-o-lock-closed')
                    ->color('danger')
                    ->requiresConfirmation()
                    ->modalDescription('Warga tidak akan dapat login sampai akun diaktifkan kembali.')
                    ->visible(fn (User $record): bool => $record->is_active)
                    ->action(function (User $record): void {
                        $record->tokens()->delete();
                        $record->update(['is_active' => false]);

                        Notification::make()
                            ->success()
                            ->title('Akun warga dinonaktifkan')
                            ->body('Seluruh token login mobile warga telah dicabut.')
                            ->send();
                    }),
                Action::make('resetPassword')
                    ->label('Reset password')
                    ->icon('heroicon-o-key')
                    ->color('warning')
                    ->schema([
                        TextInput::make('password')
                            ->label('Password baru')
                            ->password()
                            ->revealable()
                            ->confirmed()
                            ->minLength(8)
                            ->maxLength(255)
                            ->required(),
                        TextInput::make('password_confirmation')
                            ->label('Konfirmasi password baru')
                            ->password()
                            ->revealable()
                            ->dehydrated(false)
                            ->required(),
                    ])
                    ->modalSubmitActionLabel('Simpan password')
                    ->action(function (User $record, array $data): void {
                        $record->tokens()->delete();
                        $record->update(['password' => $data['password']]);

                        Notification::make()
                            ->success()
                            ->title('Password berhasil direset')
                            ->body('Token login lama dicabut. Warga harus login ulang memakai password baru.')
                            ->send();
                    }),
            ])
            ->defaultSort('house_code')
            ->striped();
    }
}
