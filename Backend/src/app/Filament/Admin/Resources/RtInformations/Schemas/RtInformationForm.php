<?php

declare(strict_types=1);

namespace App\Filament\Admin\Resources\RtInformations\Schemas;

use Filament\Forms\Components\DateTimePicker;
use Filament\Forms\Components\FileUpload;
use Filament\Forms\Components\RichEditor;
use Filament\Forms\Components\TextInput;
use Filament\Schemas\Components\Section;
use Filament\Schemas\Schema;

final class RtInformationForm
{
    public static function configure(Schema $schema): Schema
    {
        return $schema
            ->components([
                Section::make('Konten Informasi')
                    ->schema([
                        TextInput::make('title')
                            ->label('Judul')
                            ->required()
                            ->maxLength(255)
                            ->columnSpanFull(),
                        RichEditor::make('content')
                            ->label('Isi informasi')
                            ->required()
                            ->columnSpanFull(),
                        FileUpload::make('image_path')
                            ->label('Gambar informasi')
                            ->disk('public')
                            ->directory('rt-informations')
                            ->visibility('public')
                            ->image()
                            ->acceptedFileTypes(['image/jpeg', 'image/png'])
                            ->imageEditor()
                            ->imageEditorAspectRatioOptions([null, '16:9', '4:3', '1:1'])
                            ->maxSize(4096)
                            ->preventFilePathTampering()
                            ->helperText('Opsional. Format JPG/PNG, maksimal 4 MB.')
                            ->columnSpanFull(),
                    ]),
                Section::make('Publikasi')
                    ->description('Kosongkan tanggal jika informasi masih berupa draf.')
                    ->schema([
                        DateTimePicker::make('published_at')
                            ->label('Terbitkan pada')
                            ->seconds(false)
                            ->native(false)
                            ->helperText('Tanggal masa depan akan menjadwalkan publikasi otomatis.'),
                    ]),
            ]);
    }
}
