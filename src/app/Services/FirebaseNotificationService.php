<?php

declare(strict_types=1);

namespace App\Services;

use App\Enums\EmergencyReportStatus;
use App\Models\EmergencyReport;
use App\Models\User;
use Illuminate\Support\Str;
use Kreait\Firebase\Factory;
use Kreait\Firebase\Messaging\AndroidConfig;
use Kreait\Firebase\Messaging\CloudMessage;
use Kreait\Firebase\Messaging\Notification;
use Throwable;

final class FirebaseNotificationService
{
    /**
     * Mengirim notifikasi biasa ke satu user.
     *
     * @param array<string, mixed> $data
     */
    public function sendToUser(
        User $user,
        string $title,
        string $body,
        array $data = [],
        string $channelId = 'general_notifications',
        string $sound = 'default',
        bool $highPriority = false,
    ): void {
        $tokens = $user->deviceTokens()
            ->where('is_active', true)
            ->pluck('token')
            ->all();

        if ($tokens === []) {
            return;
        }

        foreach ($tokens as $token) {
            try {
                $this->sendToToken(
                    token: (string) $token,
                    title: $title,
                    body: $body,
                    data: $data,
                    channelId: $channelId,
                    sound: $sound,
                    highPriority: $highPriority,
                );
            } catch (Throwable $exception) {
                report($exception);
            }
        }
    }

    /**
     * Mengirim Emergency Alert ketika laporan baru dibuat.
     *
     * Penerima:
     * - role warga
     * - akun aktif
     * - akun terverifikasi
     * - termasuk warga pelapor
     */
    public function sendEmergencyAlertToResidents(
        EmergencyReport $report
    ): void {
        $report->loadMissing('user');

        $houseCode =
            $report->user?->house_code
            ?? 'lokasi warga';

        $type =
            $report->emergency_type->label();

        $description = Str::limit(
            trim((string) $report->description),
            100
        );

        $title = '🚨 LAPORAN DARURAT RT 20';

        $body =
            "{$type} dilaporkan di rumah {$houseCode}.";

        if ($description !== '') {
            $body .= " {$description}";
        }

        $this->sendToAllActiveResidents(
            title: $title,
            body: $body,
            data: [
                'notification_type' =>
                    'emergency_alert',

                'report_id' =>
                    (string) $report->getKey(),

                'emergency_type' =>
                    $report->emergency_type->value,

                'status' =>
                    $report->status->value,

                'house_code' =>
                    (string) $houseCode,
            ],
            channelId: 'emergency_alert',
            sound: 'emergency_alert',
            highPriority: true,
        );
    }

    /**
     * Mengirim pembaruan laporan darurat
     * ke seluruh warga aktif.
     */
    public function sendEmergencyUpdateToResidents(
        EmergencyReport $report
    ): void {
        $report->loadMissing('user');

        $houseCode =
            $report->user?->house_code
            ?? 'lokasi warga';

        $type =
            $report->emergency_type->label();

        $status =
            $report->status->label();

        $title = match ($report->status) {
            EmergencyReportStatus::IN_PROGRESS =>
                '🚨 Laporan Darurat Sedang Ditangani',

            EmergencyReportStatus::RESOLVED =>
                '✅ Laporan Darurat Selesai',

            default =>
                'Pembaruan Laporan Darurat',
        };

        $body =
            "{$type} di rumah {$houseCode}. "
            ."Status: {$status}.";

        if (filled($report->feedback)) {
            $body .= ' '
                .Str::limit(
                    trim(
                        (string) $report->feedback
                    ),
                    120
                );
        }

        $this->sendToAllActiveResidents(
            title: $title,
            body: $body,
            data: [
                'notification_type' =>
                    'emergency_update',

                'report_id' =>
                    (string) $report->getKey(),

                'emergency_type' =>
                    $report->emergency_type->value,

                'status' =>
                    $report->status->value,

                'house_code' =>
                    (string) $houseCode,
            ],
            channelId: 'emergency_update',
            sound: 'default',
            highPriority: true,
        );
    }

    /**
     * Mengirim notifikasi ke seluruh warga
     * aktif dan terverifikasi.
     *
     * Termasuk pelapor apabila akunnya memenuhi
     * kriteria tersebut.
     *
     * @param array<string, mixed> $data
     */
    private function sendToAllActiveResidents(
        string $title,
        string $body,
        array $data,
        string $channelId,
        string $sound,
        bool $highPriority,
    ): void {
        $users = User::query()
            ->where('is_active', true)
            ->where(
                'verification_status',
                'verified'
            )
            ->whereHas(
                'roles',
                fn ($query) =>
                    $query->where(
                        'name',
                        'warga'
                    )
            )
            ->get();

        foreach ($users as $user) {
            try {
                $this->sendToUser(
                    user: $user,
                    title: $title,
                    body: $body,
                    data: $data,
                    channelId: $channelId,
                    sound: $sound,
                    highPriority: $highPriority,
                );
            } catch (Throwable $exception) {
                report($exception);
            }
        }
    }

    /**
     * Kirim FCM ke satu device token.
     *
     * @param array<string, mixed> $data
     */
    public function sendToToken(
        string $token,
        string $title,
        string $body,
        array $data = [],
        string $channelId = 'general_notifications',
        string $sound = 'default',
        bool $highPriority = false,
    ): void {
        /*
         * FCM mensyaratkan seluruh value
         * data payload berupa string.
         */
        $stringData = [];

        foreach ($data as $key => $value) {
            $stringData[(string) $key] =
                (string) $value;
        }

        $androidConfig =
            AndroidConfig::fromArray([
                'priority' =>
                    $highPriority
                        ? 'high'
                        : 'normal',

                'notification' => [
                    'channel_id' =>
                        $channelId,

                    'sound' =>
                        $sound,
                ],
            ]);

        $message = CloudMessage::new()
            ->withToken($token)
            ->withNotification(
                Notification::create(
                    $title,
                    $body,
                )
            )
            ->withData($stringData)
            ->withAndroidConfig(
                $androidConfig
            );

        $this->messaging()->send(
            $message
        );
    }

    private function messaging()
    {
        $credentials =
            (string) config(
                'firebase.credentials'
            );

        return (new Factory())
            ->withServiceAccount(
                $credentials
            )
            ->createMessaging();
    }
}
