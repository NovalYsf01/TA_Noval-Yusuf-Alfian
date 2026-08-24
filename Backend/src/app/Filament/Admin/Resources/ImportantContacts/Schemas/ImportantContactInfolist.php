<?php

declare(strict_types=1);

namespace App\Filament\Admin\Resources\ImportantContacts\Schemas;

use Filament\Infolists\Components\IconEntry;
use Filament\Infolists\Components\TextEntry;
use Filament\Schemas\Components\Section;
use Filament\Schemas\Schema;

final class ImportantContactInfolist
{
    public static function configure(Schema $schema): Schema
    {
        return $schema
            ->components([
                Section::make('Nomor Penting')
                    ->schema([
                        TextEntry::make('name')
                            ->label('Nama instansi/kontak')
                            ->weight('bold'),
                        TextEntry::make('category')
                            ->label('Kategori')
                            ->badge(),
                        TextEntry::make('phone_number')
                            ->label('Nomor telepon')
                            ->copyable(),
                        IconEntry::make('is_active')
                            ->label('Aktif')
                            ->boolean(),
                        TextEntry::make('description')
                            ->label('Keterangan')
                            ->placeholder('-')
                            ->columnSpanFull(),
                        TextEntry::make('updated_at')
                            ->label('Terakhir diubah')
                            ->dateTime('d M Y H:i'),
                    ])
                    ->columns(2),
            ]);
    }
}
