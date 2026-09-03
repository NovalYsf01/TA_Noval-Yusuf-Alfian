<?php

declare(strict_types=1);

namespace App\Filament\Admin\Resources\EmergencyReports\Schemas;

use App\Enums\EmergencyReportStatus;
use App\Enums\EmergencyType;
use Filament\Infolists\Components\ImageEntry;
use Filament\Infolists\Components\TextEntry;
use Filament\Schemas\Components\Section;
use Filament\Schemas\Schema;

final class EmergencyReportInfolist
{
    public static function configure(
        Schema $schema
    ): Schema {
        return $schema
            ->components([
                Section::make(
                    'Detail Keadaan Darurat'
                )
                    ->description(
                        'Informasi laporan darurat yang dikirim oleh warga.'
                    )
                    ->schema([
                        TextEntry::make(
                            'emergency_type'
                        )
                            ->label(
                                'Jenis Keadaan Darurat'
                            )
                            ->formatStateUsing(
                                fn (
                                    EmergencyType $state
                                ): string =>
                                    $state->label()
                            )
                            ->badge()
                            ->color('danger'),

                        TextEntry::make(
                            'reported_at'
                        )
                            ->label(
                                'Waktu Laporan'
                            )
                            ->dateTime(
                                'd M Y H:i:s'
                            ),

                        TextEntry::make(
                            'description'
                        )
                            ->label(
                                'Keterangan'
                            )
                            ->columnSpanFull(),
                    ])
                    ->columns(2),

                Section::make(
                    'Pelapor'
                )
                    ->schema([
                        TextEntry::make(
                            'user.name'
                        )
                            ->label(
                                'Nama Warga'
                            )
                            ->weight(
                                'bold'
                            ),

                        TextEntry::make(
                            'user.house_code'
                        )
                            ->label(
                                'Kode Rumah'
                            )
                            ->badge(),

                        TextEntry::make(
                            'user.phone'
                        )
                            ->label(
                                'Nomor Telepon'
                            )
                            ->copyable()
                            ->placeholder(
                                '-'
                            ),

                        TextEntry::make(
                            'user.address'
                        )
                            ->label('Alamat')
                            ->columnSpanFull(),
                    ])
                    ->columns(2),

                Section::make(
                    'Penanganan Pengurus RT'
                )
                    ->description(
                        'Status dan hasil tindak lanjut laporan darurat.'
                    )
                    ->schema([
                        TextEntry::make(
                            'status'
                        )
                            ->label(
                                'Status Penanganan'
                            )
                            ->formatStateUsing(
                                fn (
                                    EmergencyReportStatus $state
                                ): string =>
                                    $state->label()
                            )
                            ->badge()
                            ->color(
                                fn (
                                    EmergencyReportStatus $state
                                ): string =>
                                    $state->color()
                            ),

                        TextEntry::make(
                            'handler.name'
                        )
                            ->label(
                                'Ditangani Oleh'
                            )
                            ->placeholder(
                                'Belum ditangani'
                            ),

                        TextEntry::make(
                            'handled_at'
                        )
                            ->label(
                                'Mulai Ditangani'
                            )
                            ->dateTime(
                                'd M Y H:i:s'
                            )
                            ->placeholder(
                                '-'
                            ),

                        TextEntry::make(
                            'resolved_at'
                        )
                            ->label(
                                'Selesai Ditangani'
                            )
                            ->dateTime(
                                'd M Y H:i:s'
                            )
                            ->placeholder(
                                '-'
                            ),

                        TextEntry::make(
                            'feedback'
                        )
                            ->label(
                                'Feedback / Catatan Pengurus RT'
                            )
                            ->placeholder(
                                'Belum ada feedback.'
                            )
                            ->columnSpanFull(),

                        ImageEntry::make(
                            'evidence_photo_path'
                        )
                            ->label(
                                'Foto Bukti Penanganan'
                            )
                            ->disk('public')
                            ->visibility(
                                'public'
                            )
                            ->placeholder(
                                'Belum ada foto bukti.'
                            )
                            ->columnSpanFull(),

                        TextEntry::make(
                            'archived_at'
                        )
                            ->label(
                                'Waktu Diarsipkan'
                            )
                            ->dateTime(
                                'd M Y H:i:s'
                            )
                            ->placeholder(
                                'Belum diarsipkan'
                            ),
                    ])
                    ->columns(2),
            ]);
    }
}
