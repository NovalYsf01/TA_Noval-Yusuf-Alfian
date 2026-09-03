<?php

declare(strict_types=1);

namespace App\Filament\Admin\Resources\Warga\Schemas;

use Filament\Forms\Components\FileUpload;
use Filament\Forms\Components\TextInput;
use Filament\Forms\Components\Textarea;
use Filament\Forms\Components\Toggle;
use Filament\Schemas\Components\Section;
use Filament\Schemas\Schema;

final class WargaForm
{
    public static function configure(Schema $schema): Schema
    {
        return $schema
            ->components([
                Section::make('Identitas Warga')
                    ->description(
                        'Satu rumah menggunakan satu akun aplikasi warga.'
                    )
                    ->schema([
                        FileUpload::make('avatar_url')
                            ->label('Foto profil')
                            ->disk('public')
                            ->directory('avatars/warga')
                            ->visibility('public')
                            ->image()
                            ->avatar()
                            ->imageEditor()
                            ->acceptedFileTypes([
                                'image/jpeg',
                                'image/png',
                            ])
                            ->maxSize(2048)
                            ->preventFilePathTampering()
                            ->columnSpanFull(),

                        TextInput::make('name')
                            ->label('Nama lengkap')
                            ->required()
                            ->maxLength(255),

                        TextInput::make('house_code')
                            ->label('Kode rumah')
                            ->helperText(
                                'Contoh: A-12. Nilai ini harus unik untuk menerapkan satu rumah satu akun.'
                            )
                            ->required()
                            ->maxLength(50)
                            ->unique(
                                ignoreRecord: true
                            ),

                        TextInput::make('email')
                            ->label('Email')
                            ->email()
                            ->required()
                            ->maxLength(255)
                            ->unique(
                                ignoreRecord: true
                            ),

                        TextInput::make('phone')
                            ->label('Nomor telepon')
                            ->tel()
                            ->maxLength(30),

                        Textarea::make('address')
                            ->label('Alamat lengkap')
                            ->required()
                            ->rows(3)
                            ->maxLength(2000)
                            ->columnSpanFull(),
                    ])
                    ->columns(2),

                Section::make('Akun Mobile')
                    ->schema([
                        TextInput::make('username')
                            ->label('Username')
                            ->helperText(
                                'Username dipakai warga untuk login di aplikasi mobile.'
                            )
                            ->required()
                            ->alphaDash()
                            ->maxLength(100)
                            ->unique(
                                ignoreRecord: true
                            ),

                        Toggle::make('is_active')
                            ->label('Akun aktif')
                            ->helperText(
                                'Akun nonaktif tidak dapat login ke aplikasi warga.'
                            )
                            ->default(true)
                            ->onColor('success')
                            ->offColor('danger')
                            ->onIcon(
                                'heroicon-m-check'
                            )
                            ->offIcon(
                                'heroicon-m-x-mark'
                            )
                            ->required(),

                        TextInput::make('password')
                            ->label('Password')
                            ->password()
                            ->revealable()
                            ->confirmed()
                            ->autocomplete(
                                'new-password'
                            )
                            ->minLength(8)
                            ->maxLength(255)
                            ->required(
                                fn (
                                    string $operation
                                ): bool =>
                                    $operation === 'create'
                            )
                            ->dehydrated(
                                fn (
                                    ?string $state
                                ): bool =>
                                    filled($state)
                            )
                            ->helperText(
                                'Wajib saat membuat akun. Kosongkan saat edit jika tidak ingin mengubah password.'
                            ),

                        TextInput::make(
                            'password_confirmation'
                        )
                            ->label(
                                'Konfirmasi password'
                            )
                            ->password()
                            ->revealable()
                            ->autocomplete(
                                'new-password'
                            )
                            ->dehydrated(false)
                            ->required(
                                fn (
                                    string $operation
                                ): bool =>
                                    $operation === 'create'
                            ),
                    ])
                    ->columns(2),
            ]);
    }
}
