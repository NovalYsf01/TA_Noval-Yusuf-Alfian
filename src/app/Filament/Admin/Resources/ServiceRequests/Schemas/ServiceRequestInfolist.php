<?php

declare(strict_types=1);

namespace App\Filament\Admin\Resources\ServiceRequests\Schemas;

use App\Enums\ServiceRequestStatus;
use Filament\Infolists\Components\TextEntry;
use Filament\Schemas\Components\Section;
use Filament\Schemas\Schema;

final class ServiceRequestInfolist
{
    public static function configure(Schema $schema): Schema
    {
        return $schema
            ->components([
                Section::make('Permohonan')
                    ->schema([
                        TextEntry::make('request_number')
                            ->label('Nomor permohonan')
                            ->copyable()
                            ->weight('bold'),
                        TextEntry::make('status')
                            ->label('Status')
                            ->badge()
                            ->formatStateUsing(fn (ServiceRequestStatus $state): string => $state->label())
                            ->color(fn (ServiceRequestStatus $state): string => self::statusColor($state)),
                        TextEntry::make('purpose')
                            ->label('Keperluan')
                            ->columnSpanFull(),
                        TextEntry::make('description')
                            ->label('Deskripsi')
                            ->placeholder('Tidak ada deskripsi')
                            ->columnSpanFull(),
                        TextEntry::make('attachment_path')
                            ->label('Lampiran warga')
                            ->formatStateUsing(fn (?string $state): string => filled($state) ? basename($state) : '-')
                            ->columnSpanFull(),
                    ])
                    ->columns(2),
                Section::make('Data Warga')
                    ->schema([
                        TextEntry::make('user.name')
                            ->label('Nama warga'),
                        TextEntry::make('user.house_code')
                            ->label('Kode rumah')
                            ->badge(),
                        TextEntry::make('user.phone')
                            ->label('Telepon')
                            ->copyable()
                            ->placeholder('-'),
                        TextEntry::make('user.address')
                            ->label('Alamat')
                            ->columnSpanFull(),
                    ])
                    ->columns(2),
                Section::make('Hasil dan Catatan Admin')
                    ->schema([
                        TextEntry::make('admin_note')
                            ->label('Catatan/alasan')
                            ->placeholder('Belum ada catatan')
                            ->columnSpanFull(),
                        TextEntry::make('result_document_path')
                            ->label('Dokumen hasil')
                            ->formatStateUsing(fn (?string $state): string => filled($state) ? basename($state) : 'Belum tersedia'),
                        TextEntry::make('processedBy.name')
                            ->label('Diproses oleh')
                            ->placeholder('-'),
                    ])
                    ->columns(2),
                Section::make('Waktu Proses')
                    ->schema([
                        TextEntry::make('submitted_at')
                            ->label('Diajukan')
                            ->dateTime('d M Y H:i'),
                        TextEntry::make('processed_at')
                            ->label('Mulai diproses')
                            ->dateTime('d M Y H:i')
                            ->placeholder('-'),
                        TextEntry::make('rejected_at')
                            ->label('Ditolak')
                            ->dateTime('d M Y H:i')
                            ->placeholder('-'),
                        TextEntry::make('completed_at')
                            ->label('Selesai')
                            ->dateTime('d M Y H:i')
                            ->placeholder('-'),
                    ])
                    ->columns(2),
            ]);
    }

    private static function statusColor(ServiceRequestStatus $status): string
    {
        return match ($status) {
            ServiceRequestStatus::PENDING_VERIFICATION => 'warning',
            ServiceRequestStatus::PROCESSING => 'info',
            ServiceRequestStatus::REJECTED => 'danger',
            ServiceRequestStatus::COMPLETED => 'success',
        };
    }
}
