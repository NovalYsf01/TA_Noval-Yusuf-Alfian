<?php

declare(strict_types=1);

namespace App\Filament\Admin\Resources\ServiceRequests\Actions;

use App\Enums\ServiceRequestStatus;
use App\Models\ServiceRequest;
use App\Models\User;
use App\Services\FirebaseNotificationService;
use Filament\Actions\Action;
use Filament\Forms\Components\FileUpload;
use Filament\Forms\Components\Textarea;
use Filament\Notifications\Notification;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Storage;
use Illuminate\Validation\ValidationException;
use function Illuminate\Support\defer;
use Throwable;

final class ServiceRequestActions
{
    public static function process(): Action
    {
        return Action::make('process')
            ->label('Proses')
            ->icon('heroicon-o-arrow-path')
            ->color('info')
            ->requiresConfirmation()
            ->modalHeading('Proses permohonan pelayanan?')
            ->modalDescription('Status akan berubah menjadi Diproses dan warga dapat melihat perubahan ini di aplikasi mobile.')
            ->modalSubmitActionLabel('Ya, proses')
            ->visible(fn (ServiceRequest $record): bool => $record->status === ServiceRequestStatus::PENDING_VERIFICATION)
            ->action(function (ServiceRequest $record): void {
                self::transition(
                    record: $record,
                    nextStatus: ServiceRequestStatus::PROCESSING,
                    attributes: [
                        'processed_by' => auth()->id(),
                        'processed_at' => now(),
                    ],
                );

                self::success(
                    'Permohonan mulai diproses',
                    'Status pelayanan berhasil diubah menjadi Diproses.',
                );
            });
    }

    public static function reject(): Action
    {
        return Action::make('reject')
            ->label('Tolak')
            ->icon('heroicon-o-x-circle')
            ->color('danger')
            ->schema([
                Textarea::make('admin_note')
                    ->label('Alasan penolakan')
                    ->helperText('Alasan ini akan ditampilkan kepada warga di aplikasi mobile.')
                    ->required()
                    ->rows(4)
                    ->maxLength(2000),
            ])
            ->modalHeading('Tolak permohonan pelayanan')
            ->modalSubmitActionLabel('Tolak permohonan')
            ->visible(fn (ServiceRequest $record): bool => $record->status === ServiceRequestStatus::PENDING_VERIFICATION)
            ->action(function (ServiceRequest $record, array $data): void {
                $note = mb_trim((string) $data['admin_note']);

                self::transition(
                    record: $record,
                    nextStatus: ServiceRequestStatus::REJECTED,
                    attributes: [
                        'admin_note' => $note,
                        'processed_by' => auth()->id(),
                        'rejected_at' => now(),
                    ],
                    historyNote: $note,
                );

                self::success(
                    'Permohonan ditolak',
                    'Alasan penolakan tersimpan dan dapat dilihat oleh warga.',
                );
            });
    }

    public static function complete(): Action
    {
        return Action::make('complete')
            ->label('Selesaikan')
            ->icon('heroicon-o-check-circle')
            ->color('success')
            ->schema([
                FileUpload::make('result_document_path')
                    ->label('Dokumen hasil pelayanan')
                    ->helperText('Wajib PDF, maksimal 5 MB. File disimpan secara privat.')
                    ->disk('local')
                    ->directory('service-requests/results')
                    ->visibility('private')
                    ->acceptedFileTypes(['application/pdf'])
                    ->maxSize(5120)
                    ->preventFilePathTampering()
                    ->required(),

                Textarea::make('admin_note')
                    ->label('Catatan untuk warga')
                    ->rows(3)
                    ->maxLength(2000),
            ])
            ->modalHeading('Selesaikan permohonan pelayanan')
            ->modalDescription('Unggah PDF final yang nantinya dapat diunduh warga melalui aplikasi mobile.')
            ->modalSubmitActionLabel('Simpan dan selesaikan')
            ->visible(fn (ServiceRequest $record): bool => $record->status === ServiceRequestStatus::PROCESSING)
            ->action(function (ServiceRequest $record, array $data): void {
                $resultDocumentPath = (string) $data['result_document_path'];

                $note = filled($data['admin_note'] ?? null)
                    ? mb_trim((string) $data['admin_note'])
                    : $record->admin_note;

                try {
                    self::transition(
                        record: $record,
                        nextStatus: ServiceRequestStatus::COMPLETED,
                        attributes: [
                            'admin_note' => $note,
                            'result_document_path' => $resultDocumentPath,
                            'processed_by' => auth()->id(),
                            'completed_at' => now(),
                        ],
                        historyNote: filled($data['admin_note'] ?? null)
                            ? mb_trim((string) $data['admin_note'])
                            : null,
                    );
                } catch (Throwable $exception) {
                    Storage::disk('local')->delete($resultDocumentPath);

                    throw $exception;
                }

                self::success(
                    'Permohonan selesai',
                    'PDF hasil pelayanan tersimpan dan siap diunduh warga.',
                );
            });
    }

    public static function downloadAttachment(): Action
    {
        return Action::make('downloadAttachment')
            ->label('Unduh lampiran warga')
            ->icon('heroicon-o-arrow-down-tray')
            ->color('gray')
            ->visible(
                fn (ServiceRequest $record): bool => filled($record->attachment_path)
            )
            ->action(function (ServiceRequest $record) {
                abort_unless(
                    filled($record->attachment_path)
                    && Storage::disk('local')->exists($record->attachment_path),
                    404,
                    'Lampiran tidak ditemukan.',
                );

                return Storage::disk('local')->download(
                    $record->attachment_path,
                    "lampiran-{$record->request_number}."
                    .pathinfo(
                        $record->attachment_path,
                        PATHINFO_EXTENSION,
                    ),
                );
            });
    }

    public static function downloadResult(): Action
    {
        return Action::make('downloadResult')
            ->label('Unduh PDF hasil')
            ->icon('heroicon-o-document-arrow-down')
            ->color('success')
            ->visible(
                fn (ServiceRequest $record): bool => filled($record->result_document_path)
            )
            ->action(function (ServiceRequest $record) {
                abort_unless(
                    filled($record->result_document_path)
                    && Storage::disk('local')->exists($record->result_document_path),
                    404,
                    'Dokumen hasil tidak ditemukan.',
                );

                return Storage::disk('local')->download(
                    $record->result_document_path,
                    "hasil-{$record->request_number}.pdf",
                    [
                        'Content-Type' => 'application/pdf',
                    ],
                );
            });
    }

    /**
     * @param array<string, mixed> $attributes
     */
    private static function transition(
        ServiceRequest $record,
        ServiceRequestStatus $nextStatus,
        array $attributes,
        ?string $historyNote = null,
    ): void {
        DB::transaction(
            function () use (
                $record,
                $nextStatus,
                $attributes,
                $historyNote,
            ): void {
                /** @var ServiceRequest $lockedRecord */
                $lockedRecord = ServiceRequest::query()
                    ->lockForUpdate()
                    ->findOrFail($record->getKey());

                if (! $lockedRecord->canTransitionTo($nextStatus)) {
                    throw ValidationException::withMessages([
                        'status' =>
                            "Status {$lockedRecord->status->label()} "
                            ."tidak dapat diubah menjadi "
                            ."{$nextStatus->label()}.",
                    ]);
                }

                $oldStatus = $lockedRecord->status;

                $lockedRecord->fill([
                    ...$attributes,
                    'status' => $nextStatus,
                ])->save();

                /** @var User|null $admin */
                $admin = auth()->user();

                $lockedRecord->statusHistories()->create([
                    'changed_by' => $admin?->getKey(),
                    'old_status' => $oldStatus,
                    'new_status' => $nextStatus,
                    'note' => $historyNote,
                ]);
            }
        );

        /*
         * Sampai di sini transaksi database sudah berhasil.
         * Baru setelah itu kita refresh data dan mengirim push notification.
         */
        $record->refresh();

        $recordId = $record->getKey();

        defer(function () use ($recordId, $nextStatus): void {
            /** @var ServiceRequest|null $freshRecord */
            $freshRecord = ServiceRequest::query()->find($recordId);

            if ($freshRecord === null) {
                return;
            }

            self::sendStatusNotification(
                record: $freshRecord,
                status: $nextStatus,
            );
        });
    }

    /**
     * Kirim push notification ke pemilik permohonan.
     *
     * Kegagalan Firebase tidak akan menggagalkan perubahan status
     * yang sudah berhasil disimpan di database.
     */
    private static function sendStatusNotification(
        ServiceRequest $record,
        ServiceRequestStatus $status,
    ): void {
        try {
            /** @var User|null $user */
            $user = $record->user()->first();

            if ($user === null) {
                return;
            }

            [$title, $body] = match ($status) {
                ServiceRequestStatus::PROCESSING => [
                    'Permohonan Sedang Diproses',
                    "Permohonan {$record->request_number} "
                    .'sedang diproses oleh pengurus RT.',
                ],

                ServiceRequestStatus::REJECTED => [
                    'Permohonan Ditolak',
                    "Permohonan {$record->request_number} "
                    .'ditolak. Buka aplikasi untuk melihat alasan penolakan.',
                ],

                ServiceRequestStatus::COMPLETED => [
                    'Permohonan Selesai',
                    "Permohonan {$record->request_number} "
                    .'telah selesai. Dokumen hasil sudah tersedia di aplikasi.',
                ],

                default => [
                    'Status Permohonan Diperbarui',
                    "Status permohonan {$record->request_number} "
                    .'telah diperbarui.',
                ],
            };

            app(FirebaseNotificationService::class)->sendToUser(
                user: $user,
                title: $title,
                body: $body,
            );
        } catch (Throwable $exception) {
            /*
             * Firebase gagal tidak boleh membatalkan status pelayanan.
             * Error tetap dicatat di log Laravel.
             */
            report($exception);
        }
    }

    private static function success(
        string $title,
        string $body,
    ): void {
        Notification::make()
            ->success()
            ->title($title)
            ->body($body)
            ->send();
    }
}