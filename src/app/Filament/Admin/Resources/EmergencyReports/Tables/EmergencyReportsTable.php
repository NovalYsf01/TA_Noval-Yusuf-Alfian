<?php

declare(strict_types=1);

namespace App\Filament\Admin\Resources\EmergencyReports\Tables;

use App\Enums\EmergencyReportStatus;
use App\Enums\EmergencyType;
use App\Models\EmergencyReport;
use App\Services\FirebaseNotificationService;
use Filament\Actions\Action;
use Filament\Actions\ViewAction;
use Filament\Forms\Components\FileUpload;
use Filament\Forms\Components\Textarea;
use Filament\Notifications\Notification;
use Filament\Tables\Columns\IconColumn;
use Filament\Tables\Columns\TextColumn;
use Filament\Tables\Filters\Filter;
use Filament\Tables\Filters\SelectFilter;
use Filament\Tables\Table;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Support\Facades\Storage;
use Throwable;

final class EmergencyReportsTable
{
    public static function configure(Table $table): Table
    {
        return $table
            ->columns([
                TextColumn::make('emergency_type')
                    ->label('Jenis Darurat')
                    ->formatStateUsing(
                        fn (EmergencyType $state): string =>
                            $state->label()
                    )
                    ->badge()
                    ->color('danger')
                    ->sortable(),

                TextColumn::make('user.name')
                    ->label('Pelapor')
                    ->description(
                        fn (EmergencyReport $record): string =>
                            $record->user->house_code ?? '-'
                    )
                    ->searchable()
                    ->sortable(),

                TextColumn::make('status')
                    ->label('Status')
                    ->badge()
                    ->formatStateUsing(
                        fn (
                            EmergencyReportStatus $state
                        ): string =>
                            $state->label()
                    )
                    ->color(
                        fn (
                            EmergencyReportStatus $state
                        ): string =>
                            $state->color()
                    )
                    ->sortable(),

                TextColumn::make('feedback')
                    ->label('Feedback RT')
                    ->limit(50)
                    ->placeholder('Belum ada feedback')
                    ->wrap()
                    ->toggleable(),

                IconColumn::make('archived_at')
                    ->label('Arsip')
                    ->boolean()
                    ->getStateUsing(
                        fn (
                            EmergencyReport $record
                        ): bool =>
                            $record->archived_at !== null
                    ),

                TextColumn::make('reported_at')
                    ->label('Dilaporkan')
                    ->dateTime('d M Y H:i:s')
                    ->sortable(),

                TextColumn::make('handler.name')
                    ->label('Ditangani Oleh')
                    ->placeholder('-')
                    ->toggleable(
                        isToggledHiddenByDefault: true
                    ),
            ])

            ->filters([
                SelectFilter::make('emergency_type')
                    ->label('Jenis Darurat')
                    ->options(
                        self::typeOptions()
                    )
                    ->native(false),

                SelectFilter::make('status')
                    ->label('Status Penanganan')
                    ->options([
                        EmergencyReportStatus::WAITING->value =>
                            EmergencyReportStatus::WAITING->label(),

                        EmergencyReportStatus::IN_PROGRESS->value =>
                            EmergencyReportStatus::IN_PROGRESS->label(),

                        EmergencyReportStatus::RESOLVED->value =>
                            EmergencyReportStatus::RESOLVED->label(),
                    ])
                    ->native(false),

                Filter::make('active')
                    ->label('Belum Diarsipkan')
                    ->query(
                        fn (
                            Builder $query
                        ): Builder =>
                            $query->whereNull(
                                'archived_at'
                            )
                    ),

                Filter::make('archived')
                    ->label('Arsip')
                    ->query(
                        fn (
                            Builder $query
                        ): Builder =>
                            $query->whereNotNull(
                                'archived_at'
                            )
                    ),

                Filter::make('today')
                    ->label('Hari Ini')
                    ->query(
                        fn (
                            Builder $query
                        ): Builder =>
                            $query->whereDate(
                                'reported_at',
                                today()
                            )
                    ),
            ])

            ->recordActions([
                ViewAction::make()
                    ->label('Lihat')
                    ->icon('heroicon-o-eye'),

                /*
                 * MULAI PENANGANAN
                 */
                Action::make('startHandling')
                    ->label('Tangani')
                    ->icon(
                        'heroicon-o-hand-raised'
                    )
                    ->color('warning')
                    ->requiresConfirmation()
                    ->modalHeading(
                        'Mulai Penanganan'
                    )
                    ->modalDescription(
                        fn (
                            EmergencyReport $record
                        ): string =>
                            "Mulai menangani laporan {$record->emergency_type->label()} dari {$record->user->name}?"
                    )
                    ->modalSubmitActionLabel(
                        'Ya, Mulai Tangani'
                    )
                    ->visible(
                        fn (
                            EmergencyReport $record
                        ): bool =>
                            $record->status
                                === EmergencyReportStatus::WAITING
                            && ! $record->isArchived()
                    )
                    ->action(
                        function (
                            EmergencyReport $record
                        ): void {
                            $record->update([
                                'status' =>
                                    EmergencyReportStatus::IN_PROGRESS,

                                'handled_by' =>
                                    auth()->id(),

                                'handled_at' =>
                                    now(),

                                'resolved_at' =>
                                    null,
                            ]);

                            self::sendEmergencyUpdate(
                                $record
                            );

                            Notification::make()
                                ->success()
                                ->title(
                                    'Penanganan dimulai'
                                )
                                ->body(
                                    'Status menjadi Sedang Ditangani dan pembaruan dikirim kepada warga.'
                                )
                                ->send();
                        }
                    ),

                /*
                 * FEEDBACK / CATATAN PENANGANAN
                 */
                Action::make('updateHandling')
                    ->label('Feedback')
                    ->icon(
                        'heroicon-o-chat-bubble-left-right'
                    )
                    ->color('info')
                    ->schema([
                        Textarea::make('feedback')
                            ->label(
                                'Feedback / Catatan Penanganan'
                            )
                            ->placeholder(
                                'Contoh: Pengurus RT sudah berada di lokasi dan melakukan penanganan awal.'
                            )
                            ->rows(5)
                            ->required()
                            ->maxLength(2000),

                        FileUpload::make(
                            'evidence_photo_path'
                        )
                            ->label(
                                'Foto Bukti Penanganan'
                            )
                            ->image()
                            ->disk('public')
                            ->directory(
                                'emergency-evidence'
                            )
                            ->visibility('public')
                            ->maxSize(4096)
                            ->acceptedFileTypes([
                                'image/jpeg',
                                'image/png',
                                'image/webp',
                            ]),
                    ])
                    ->fillForm(
                        fn (
                            EmergencyReport $record
                        ): array => [
                            'feedback' =>
                                $record->feedback,

                            'evidence_photo_path' =>
                                $record
                                    ->evidence_photo_path,
                        ]
                    )
                    ->modalHeading(
                        'Perbarui Penanganan'
                    )
                    ->modalSubmitActionLabel(
                        'Simpan Feedback'
                    )
                    ->visible(
                        fn (
                            EmergencyReport $record
                        ): bool =>
                            in_array(
                                $record->status,
                                [
                                    EmergencyReportStatus::IN_PROGRESS,
                                    EmergencyReportStatus::RESOLVED,
                                ],
                                true
                            )
                            && ! $record->isArchived()
                    )
                    ->action(
                        function (
                            EmergencyReport $record,
                            array $data
                        ): void {
                            $newPhoto =
                                $data[
                                    'evidence_photo_path'
                                ] ?? null;

                            if (
                                filled($newPhoto)
                                && filled(
                                    $record
                                        ->evidence_photo_path
                                )
                                && $newPhoto
                                    !== $record
                                        ->evidence_photo_path
                            ) {
                                Storage::disk(
                                    'public'
                                )->delete(
                                    (string) $record
                                        ->evidence_photo_path
                                );
                            }

                            $record->update([
                                'feedback' =>
                                    $data['feedback'],

                                'evidence_photo_path' =>
                                    $newPhoto
                                    ?: $record
                                        ->evidence_photo_path,

                                'handled_by' =>
                                    $record->handled_by
                                    ?? auth()->id(),

                                'handled_at' =>
                                    $record->handled_at
                                    ?? now(),
                            ]);

                            self::sendEmergencyUpdate(
                                $record
                            );

                            Notification::make()
                                ->success()
                                ->title(
                                    'Feedback diperbarui'
                                )
                                ->body(
                                    'Feedback disimpan dan pembaruan dikirim kepada warga.'
                                )
                                ->send();
                        }
                    ),

                /*
                 * SELESAIKAN LAPORAN
                 */
                Action::make('resolve')
                    ->label('Selesaikan')
                    ->icon(
                        'heroicon-o-check-circle'
                    )
                    ->color('success')
                    ->schema([
                        Textarea::make('feedback')
                            ->label(
                                'Feedback Akhir'
                            )
                            ->placeholder(
                                'Jelaskan hasil akhir penanganan laporan darurat.'
                            )
                            ->rows(5)
                            ->required()
                            ->maxLength(2000),

                        FileUpload::make(
                            'evidence_photo_path'
                        )
                            ->label(
                                'Foto Bukti Penanganan'
                            )
                            ->image()
                            ->disk('public')
                            ->directory(
                                'emergency-evidence'
                            )
                            ->visibility('public')
                            ->maxSize(4096)
                            ->acceptedFileTypes([
                                'image/jpeg',
                                'image/png',
                                'image/webp',
                            ]),
                    ])
                    ->fillForm(
                        fn (
                            EmergencyReport $record
                        ): array => [
                            'feedback' =>
                                $record->feedback,

                            'evidence_photo_path' =>
                                $record
                                    ->evidence_photo_path,
                        ]
                    )
                    ->modalHeading(
                        'Selesaikan Laporan Darurat'
                    )
                    ->modalDescription(
                        'Pastikan feedback akhir menjelaskan hasil penanganan.'
                    )
                    ->modalSubmitActionLabel(
                        'Tandai Selesai'
                    )
                    ->visible(
                        fn (
                            EmergencyReport $record
                        ): bool =>
                            $record->status
                                === EmergencyReportStatus::IN_PROGRESS
                            && ! $record->isArchived()
                    )
                    ->action(
                        function (
                            EmergencyReport $record,
                            array $data
                        ): void {
                            $newPhoto =
                                $data[
                                    'evidence_photo_path'
                                ] ?? null;

                            if (
                                filled($newPhoto)
                                && filled(
                                    $record
                                        ->evidence_photo_path
                                )
                                && $newPhoto
                                    !== $record
                                        ->evidence_photo_path
                            ) {
                                Storage::disk(
                                    'public'
                                )->delete(
                                    (string) $record
                                        ->evidence_photo_path
                                );
                            }

                            $record->update([
                                'status' =>
                                    EmergencyReportStatus::RESOLVED,

                                'feedback' =>
                                    $data['feedback'],

                                'evidence_photo_path' =>
                                    $newPhoto
                                    ?: $record
                                        ->evidence_photo_path,

                                'handled_by' =>
                                    $record->handled_by
                                    ?? auth()->id(),

                                'handled_at' =>
                                    $record->handled_at
                                    ?? now(),

                                'resolved_at' =>
                                    now(),
                            ]);

                            self::sendEmergencyUpdate(
                                $record
                            );

                            Notification::make()
                                ->success()
                                ->title(
                                    'Laporan selesai'
                                )
                                ->body(
                                    'Laporan ditandai selesai dan pemberitahuan dikirim kepada warga.'
                                )
                                ->send();
                        }
                    ),

                /*
                 * ARSIPKAN
                 *
                 * Arsip tidak mengirim FCM karena hanya
                 * pengelolaan histori internal admin.
                 */
                Action::make('archive')
                    ->label('Arsipkan')
                    ->icon(
                        'heroicon-o-archive-box'
                    )
                    ->color('gray')
                    ->requiresConfirmation()
                    ->modalHeading(
                        'Arsipkan Laporan'
                    )
                    ->modalDescription(
                        'Laporan tetap tersimpan sebagai histori dan dapat dilihat kembali melalui filter Arsip.'
                    )
                    ->modalSubmitActionLabel(
                        'Ya, Arsipkan'
                    )
                    ->visible(
                        fn (
                            EmergencyReport $record
                        ): bool =>
                            $record->status
                                === EmergencyReportStatus::RESOLVED
                            && ! $record->isArchived()
                    )
                    ->action(
                        function (
                            EmergencyReport $record
                        ): void {
                            $record->update([
                                'archived_at' =>
                                    now(),
                            ]);

                            Notification::make()
                                ->success()
                                ->title(
                                    'Laporan diarsipkan'
                                )
                                ->body(
                                    'Laporan tetap tersimpan dalam histori.'
                                )
                                ->send();
                        }
                    ),

                /*
                 * KELUARKAN DARI ARSIP
                 */
                Action::make('unarchive')
                    ->label(
                        'Keluarkan dari Arsip'
                    )
                    ->icon(
                        'heroicon-o-arrow-uturn-left'
                    )
                    ->color('info')
                    ->requiresConfirmation()
                    ->visible(
                        fn (
                            EmergencyReport $record
                        ): bool =>
                            $record->isArchived()
                    )
                    ->action(
                        function (
                            EmergencyReport $record
                        ): void {
                            $record->update([
                                'archived_at' =>
                                    null,
                            ]);

                            Notification::make()
                                ->success()
                                ->title(
                                    'Laporan dikembalikan'
                                )
                                ->body(
                                    'Laporan kembali ke daftar aktif.'
                                )
                                ->send();
                        }
                    ),
            ])

            ->defaultSort(
                'reported_at',
                'desc'
            )
            ->poll('15s')
            ->striped();
    }

    /**
     * Mengirim update status / feedback
     * laporan darurat kepada seluruh warga aktif
     * dan terverifikasi.
     */
    private static function sendEmergencyUpdate(
        EmergencyReport $record
    ): void {
        try {
            /** @var FirebaseNotificationService $firebase */
            $firebase = app(
                FirebaseNotificationService::class
            );

            $freshRecord =
                $record->fresh([
                    'user',
                ]);

            $firebase
                ->sendEmergencyUpdateToResidents(
                    $freshRecord ?? $record
                );
        } catch (Throwable $exception) {
            /*
             * Perubahan status dan feedback tetap
             * tersimpan walaupun FCM gagal.
             */
            report($exception);
        }
    }

    /**
     * @return array<string, string>
     */
    private static function typeOptions(): array
    {
        $options = [];

        foreach (
            EmergencyType::cases()
            as $type
        ) {
            $options[
                $type->value
            ] = $type->label();
        }

        return $options;
    }
}
