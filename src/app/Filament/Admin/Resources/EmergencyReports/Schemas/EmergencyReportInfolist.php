<?php

declare(strict_types=1);

namespace App\Filament\Admin\Resources\EmergencyReports\Schemas;

use App\Enums\EmergencyType;
use Filament\Infolists\Components\TextEntry;
use Filament\Schemas\Components\Section;
use Filament\Schemas\Schema;

final class EmergencyReportInfolist
{
    public static function configure(Schema $schema): Schema
    {
        return $schema
            ->components([
                Section::make('Detail Keadaan Darurat')
                    ->description('Laporan darurat tidak memerlukan approval. Segera tindak lanjuti melalui kontak warga.')
                    ->schema([
                        TextEntry::make('emergency_type')
                            ->label('Jenis keadaan darurat')
                            ->formatStateUsing(fn (EmergencyType $state): string => $state->label())
                            ->badge()
                            ->color('danger'),
                        TextEntry::make('reported_at')
                            ->label('Waktu laporan')
                            ->dateTime('d M Y H:i:s'),
                        TextEntry::make('description')
                            ->label('Keterangan')
                            ->columnSpanFull(),
                    ])
                    ->columns(2),
                Section::make('Pelapor')
                    ->schema([
                        TextEntry::make('user.name')
                            ->label('Nama warga')
                            ->weight('bold'),
                        TextEntry::make('user.house_code')
                            ->label('Kode rumah')
                            ->badge(),
                        TextEntry::make('user.phone')
                            ->label('Nomor telepon')
                            ->copyable()
                            ->placeholder('-'),
                        TextEntry::make('user.address')
                            ->label('Alamat')
                            ->columnSpanFull(),
                    ])
                    ->columns(2),
            ]);
    }
}
