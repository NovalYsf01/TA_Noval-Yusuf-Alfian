<?php

declare(strict_types=1);

namespace App\Listeners;

use App\Events\EmergencyReportCreated;
use App\Services\FirebaseNotificationService;
use Throwable;

final class SendEmergencyReportNotification
{
    public function __construct(
        private FirebaseNotificationService $firebase,
    ) {}

    public function handle(
        EmergencyReportCreated $event
    ): void {
        try {
            $this->firebase
                ->sendEmergencyAlertToResidents(
                    $event->emergencyReport
                );
        } catch (Throwable $exception) {
            /*
             * Kegagalan push notification tidak boleh
             * menggagalkan penyimpanan laporan darurat.
             */
            report($exception);
        }
    }
}
