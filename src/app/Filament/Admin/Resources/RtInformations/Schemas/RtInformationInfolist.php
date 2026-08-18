<?php

declare(strict_types=1);

namespace App\Filament\Admin\Resources\RtInformations\Schemas;

use Filament\Infolists\Components\ImageEntry;
use Filament\Infolists\Components\TextEntry;
use Filament\Schemas\Components\Section;
use Filament\Schemas\Schema;

final class RtInformationInfolist
{
    public static function configure(Schema $schema): Schema
    {
        return $schema
            ->components([
                Section::make('Informasi RT')
                    ->schema([
                        TextEntry::make('title')
                            ->label('Judul')
                            ->weight('bold')
                            ->columnSpanFull(),
                        ImageEntry::make('image_path')
                            ->label('Gambar')
                            ->disk('public')
                            ->visibility('public')
                            ->columnSpanFull(),
                        TextEntry::make('content')
                            ->label('Isi informasi')
                            ->html()
                            ->columnSpanFull(),
                    ]),
                Section::make('Publikasi')
                    ->schema([
                        TextEntry::make('published_at')
                            ->label('Terbit pada')
                            ->dateTime('d M Y H:i')
                            ->placeholder('Draf'),
                        TextEntry::make('creator.name')
                            ->label('Dibuat oleh')
                            ->placeholder('-'),
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
