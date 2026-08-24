<?php

declare(strict_types=1);

namespace App\Listeners;

use App\Events\EmergencyReportCreated;
use App\Models\User;
use App\Services\FirebaseNotificationService;
use Throwable;

final class SendEmergencyReportNotification
{
    public function __construct(
        private FirebaseNotificationService $firebase,
    ) {}

    public function handle(EmergencyReportCreated $event): void
    {
        $report = $event->emergencyReport;

        $users = User::query()
            ->where('id', '!=', $report->user_id)
            ->get();

        foreach ($users as $user) {
            try {
                $this->firebase->sendToUser(
                    user: $user,
                    title: 'Laporan Darurat Baru',
                    body: $report->description,
                );
            } catch (Throwable $exception) {
                report($exception);
            }
        }
    }
}
