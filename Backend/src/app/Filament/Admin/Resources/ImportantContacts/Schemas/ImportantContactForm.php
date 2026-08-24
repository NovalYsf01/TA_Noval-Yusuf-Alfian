<?php

declare(strict_types=1);

namespace App\Filament\Admin\Resources\ImportantContacts\Schemas;

use Filament\Forms\Components\Textarea;
use Filament\Forms\Components\TextInput;
use Filament\Forms\Components\Toggle;
use Filament\Schemas\Components\Section;
use Filament\Schemas\Schema;

final class ImportantContactForm
{
    public static function configure(Schema $schema): Schema
    {
        return $schema
            ->components([
                Section::make('Data Nomor Penting')
                    ->schema([
                        TextInput::make('name')
                            ->label('Nama instansi/kontak')
                            ->required()
                            ->maxLength(255),
                        TextInput::make('category')
                            ->label('Kategori')
                            ->helperText('Contoh: Keamanan, Kesehatan, Utilitas, Pemerintahan.')
                            ->required()
                            ->maxLength(100),
                        TextInput::make('phone_number')
                            ->label('Nomor telepon')
                            ->tel()
                            ->required()
                            ->maxLength(30),
                        Toggle::make('is_active')
                            ->label('Tampilkan di aplikasi warga')
                            ->default(true)
                            ->required(),
                        Textarea::make('description')
                            ->label('Keterangan')
                            ->rows(4)
                            ->maxLength(2000)
                            ->columnSpanFull(),
                    ])
                    ->columns(2),
            ]);
    }
}
