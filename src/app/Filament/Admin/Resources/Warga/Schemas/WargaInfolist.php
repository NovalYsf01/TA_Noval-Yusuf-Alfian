<?php

declare(strict_types=1);

namespace App\Filament\Admin\Resources\Warga\Schemas;

use Filament\Infolists\Components\IconEntry;
use Filament\Infolists\Components\ImageEntry;
use Filament\Infolists\Components\TextEntry;
use Filament\Schemas\Components\Section;
use Filament\Schemas\Schema;

final class WargaInfolist
{
    public static function configure(Schema $schema): Schema
    {
        return $schema
            ->components([
                Section::make('Identitas Warga')
                    ->schema([
                        ImageEntry::make('avatar_url')
                            ->label('Foto profil')
                            ->disk('public')
                            ->visibility('public')
                            ->circular()
                            ->defaultImageUrl('https://www.gravatar.com/avatar/64e1b8d34f425d19e1ee2ea7236d3028?d=mp&r=g&s=250'),
                        TextEntry::make('name')
                            ->label('Nama lengkap')
                            ->weight('bold'),
                        TextEntry::make('house_code')
                            ->label('Kode rumah')
                            ->badge(),
                        TextEntry::make('address')
                            ->label('Alamat')
                            ->columnSpanFull(),
                        TextEntry::make('email')
                            ->label('Email')
                            ->copyable(),
                        TextEntry::make('phone')
                            ->label('Nomor telepon')
                            ->copyable()
                            ->placeholder('-'),
                    ])
                    ->columns(2),
                Section::make('Akun Mobile')
                    ->schema([
                        TextEntry::make('username')
                            ->label('Username')
                            ->copyable(),
                        IconEntry::make('is_active')
                            ->label('Akun aktif')
                            ->boolean(),
                        TextEntry::make('created_at')
                            ->label('Dibuat pada')
                            ->dateTime('d M Y H:i'),
                        TextEntry::make('updated_at')
                            ->label('Terakhir diubah')
                            ->dateTime('d M Y H:i'),
                    ])
                    ->columns(2),
            ]);
    }
}
