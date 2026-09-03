<?php

declare(strict_types=1);

namespace App\Filament\Admin\Resources\Warga\Tables;

use App\Models\User;
use Filament\Actions\Action;
use Filament\Actions\DeleteAction;
use Filament\Actions\EditAction;
use Filament\Actions\ViewAction;
use Filament\Forms\Components\Textarea;
use Filament\Forms\Components\TextInput;
use Filament\Notifications\Notification;
use Filament\Tables\Columns\IconColumn;
use Filament\Tables\Columns\ImageColumn;
use Filament\Tables\Columns\TextColumn;
use Filament\Tables\Filters\SelectFilter;
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
                    ->defaultImageUrl(
                        'https://www.gravatar.com/avatar/64e1b8d34f425d19e1ee2ea7236d3028?d=mp&r=g&s=250'
                    ),

                TextColumn::make('name')
                    ->label('Nama warga')
                    ->description(
                        fn (User $record): string =>
                            $record->username ?? '-'
                    )
                    ->searchable([
                        'name',
                        'username',
                    ])
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

                TextColumn::make(
                    'verification_status'
                )
                    ->label('Verifikasi')
                    ->badge()
                    ->formatStateUsing(
                        fn (
                            ?string $state
                        ): string => match ($state) {
                            'pending' =>
                                'Menunggu',

                            'verified' =>
                                'Terverifikasi',

                            'rejected' =>
                                'Ditolak',

                            default =>
                                '-',
                        }
                    )
                    ->color(
                        fn (
                            ?string $state
                        ): string => match ($state) {
                            'pending' =>
                                'warning',

                            'verified' =>
                                'success',

                            'rejected' =>
                                'danger',

                            default =>
                                'gray',
                        }
                    )
                    ->sortable(),

                IconColumn::make('is_active')
                    ->label('Aktif')
                    ->boolean()
                    ->sortable(),

                TextColumn::make('created_at')
                    ->label('Dibuat')
                    ->dateTime('d M Y H:i')
                    ->sortable()
                    ->toggleable(
                        isToggledHiddenByDefault: true
                    ),
            ])

            ->filters([
                SelectFilter::make(
                    'verification_status'
                )
                    ->label(
                        'Status verifikasi'
                    )
                    ->options([
                        'pending' =>
                            'Menunggu',

                        'verified' =>
                            'Terverifikasi',

                        'rejected' =>
                            'Ditolak',
                    ]),

                TernaryFilter::make(
                    'is_active'
                )
                    ->label('Status akun')
                    ->trueLabel('Aktif')
                    ->falseLabel('Nonaktif')
                    ->native(false),
            ])

            ->recordActions([
                ViewAction::make()
                    ->label(''),

                EditAction::make()
                    ->label(''),

                /*
                 * SETUJUI REGISTRASI
                 */
                Action::make(
                    'approveRegistration'
                )
                    ->label('Setujui')
                    ->icon(
                        'heroicon-o-check-circle'
                    )
                    ->color('success')
                    ->requiresConfirmation()
                    ->modalHeading(
                        'Setujui Registrasi Warga'
                    )
                    ->modalDescription(
                        fn (
                            User $record
                        ): string =>
                            "Setujui akun {$record->name} untuk rumah {$record->house_code}?"
                    )
                    ->modalSubmitActionLabel(
                        'Ya, Setujui'
                    )
                    ->visible(
                        fn (
                            User $record
                        ): bool =>
                            in_array(
                                $record
                                    ->verification_status,
                                [
                                    'pending',
                                    'rejected',
                                ],
                                true
                            )
                    )
                    ->action(
                        function (
                            User $record
                        ): void {
                            $record->update([
                                'verification_status' =>
                                    'verified',

                                'verified_at' =>
                                    now(),

                                'verified_by' =>
                                    auth()->id(),

                                'rejection_reason' =>
                                    null,

                                'is_active' =>
                                    true,
                            ]);

                            Notification::make()
                                ->success()
                                ->title(
                                    'Registrasi disetujui'
                                )
                                ->body(
                                    "{$record->name} sekarang dapat login ke aplikasi mobile."
                                )
                                ->send();
                        }
                    ),

                /*
                 * TOLAK REGISTRASI
                 */
                Action::make(
                    'rejectRegistration'
                )
                    ->label('Tolak')
                    ->icon(
                        'heroicon-o-x-circle'
                    )
                    ->color('danger')
                    ->schema([
                        Textarea::make(
                            'rejection_reason'
                        )
                            ->label(
                                'Alasan penolakan'
                            )
                            ->placeholder(
                                'Contoh: Data rumah tidak sesuai dengan data warga RT.'
                            )
                            ->rows(4)
                            ->required()
                            ->maxLength(1000),
                    ])
                    ->modalHeading(
                        'Tolak Registrasi Warga'
                    )
                    ->modalDescription(
                        fn (
                            User $record
                        ): string =>
                            "Masukkan alasan penolakan untuk akun {$record->name}."
                    )
                    ->modalSubmitActionLabel(
                        'Tolak Registrasi'
                    )
                    ->visible(
                        fn (
                            User $record
                        ): bool =>
                            $record
                                ->verification_status
                            === 'pending'
                    )
                    ->action(
                        function (
                            User $record,
                            array $data
                        ): void {
                            $record
                                ->tokens()
                                ->delete();

                            $record->update([
                                'verification_status' =>
                                    'rejected',

                                'verified_at' =>
                                    null,

                                'verified_by' =>
                                    auth()->id(),

                                'rejection_reason' =>
                                    $data[
                                        'rejection_reason'
                                    ],

                                'is_active' =>
                                    false,
                            ]);

                            Notification::make()
                                ->success()
                                ->title(
                                    'Registrasi ditolak'
                                )
                                ->body(
                                    "Registrasi {$record->name} telah ditolak."
                                )
                                ->send();
                        }
                    ),

                /*
                 * HAPUS REGISTRASI.
                 *
                 * Hanya akun pending / rejected.
                 * Akun terverifikasi tidak boleh
                 * dihapus untuk menjaga histori.
                 */
                DeleteAction::make()
                    ->label('Hapus')
                    ->icon(
                        'heroicon-o-trash'
                    )
                    ->color('danger')
                    ->requiresConfirmation()
                    ->modalHeading(
                        'Hapus Registrasi Warga'
                    )
                    ->modalDescription(
                        fn (
                            User $record
                        ): string =>
                            "Hapus registrasi {$record->name} untuk rumah {$record->house_code}? Data akun akan dihapus permanen dan kode rumah dapat digunakan untuk registrasi kembali."
                    )
                    ->modalSubmitActionLabel(
                        'Ya, Hapus'
                    )
                    ->visible(
                        fn (
                            User $record
                        ): bool =>
                            in_array(
                                $record
                                    ->verification_status,
                                [
                                    'pending',
                                    'rejected',
                                ],
                                true
                            )
                    ),

                /*
                 * AKTIFKAN AKUN
                 */
                Action::make('activate')
                    ->label('Aktifkan')
                    ->icon(
                        'heroicon-o-lock-open'
                    )
                    ->color('success')
                    ->requiresConfirmation()
                    ->visible(
                        fn (
                            User $record
                        ): bool =>
                            $record
                                ->verification_status
                            === 'verified'
                            && ! $record
                                ->is_active
                    )
                    ->action(
                        function (
                            User $record
                        ): void {
                            $record->update([
                                'is_active' =>
                                    true,
                            ]);

                            Notification::make()
                                ->success()
                                ->title(
                                    'Akun warga diaktifkan'
                                )
                                ->body(
                                    "{$record->name} sekarang dapat login ke aplikasi mobile."
                                )
                                ->send();
                        }
                    ),

                /*
                 * NONAKTIFKAN AKUN
                 */
                Action::make('deactivate')
                    ->label('Nonaktifkan')
                    ->icon(
                        'heroicon-o-lock-closed'
                    )
                    ->color('danger')
                    ->requiresConfirmation()
                    ->modalDescription(
                        'Warga tidak akan dapat login sampai akun diaktifkan kembali.'
                    )
                    ->visible(
                        fn (
                            User $record
                        ): bool =>
                            $record
                                ->verification_status
                            === 'verified'
                            && $record
                                ->is_active
                    )
                    ->action(
                        function (
                            User $record
                        ): void {
                            $record
                                ->tokens()
                                ->delete();

                            $record->update([
                                'is_active' =>
                                    false,
                            ]);

                            Notification::make()
                                ->success()
                                ->title(
                                    'Akun warga dinonaktifkan'
                                )
                                ->body(
                                    'Seluruh token login mobile warga telah dicabut.'
                                )
                                ->send();
                        }
                    ),

                /*
                 * RESET PASSWORD
                 */
                Action::make(
                    'resetPassword'
                )
                    ->label(
                        'Reset password'
                    )
                    ->icon(
                        'heroicon-o-key'
                    )
                    ->color('warning')
                    ->schema([
                        TextInput::make(
                            'password'
                        )
                            ->label(
                                'Password baru'
                            )
                            ->password()
                            ->revealable()
                            ->confirmed()
                            ->minLength(8)
                            ->maxLength(255)
                            ->required(),

                        TextInput::make(
                            'password_confirmation'
                        )
                            ->label(
                                'Konfirmasi password baru'
                            )
                            ->password()
                            ->revealable()
                            ->dehydrated(false)
                            ->required(),
                    ])
                    ->modalSubmitActionLabel(
                        'Simpan password'
                    )
                    ->action(
                        function (
                            User $record,
                            array $data
                        ): void {
                            $record
                                ->tokens()
                                ->delete();

                            $record->update([
                                'password' =>
                                    $data[
                                        'password'
                                    ],
                            ]);

                            Notification::make()
                                ->success()
                                ->title(
                                    'Password berhasil direset'
                                )
                                ->body(
                                    'Token login lama dicabut. Warga harus login ulang memakai password baru.'
                                )
                                ->send();
                        }
                    ),
            ])

            ->defaultSort('house_code')
            ->striped();
    }
}
