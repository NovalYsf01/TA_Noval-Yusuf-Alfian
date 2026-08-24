<?php

declare(strict_types=1);

namespace App\Services;

use App\Models\User;
use Kreait\Firebase\Factory;
use Kreait\Firebase\Messaging\CloudMessage;
use Kreait\Firebase\Messaging\Notification;
use Throwable;

final class FirebaseNotificationService
{
    private function messaging()
    {
        $credentials = (string) config('firebase.credentials');

        return (new Factory())
            ->withServiceAccount($credentials)
            ->createMessaging();
    }

    /**
     * Kirim notifikasi ke seluruh device aktif milik user.
     */
    public function sendToUser(
        User $user,
        string $title,
        string $body,
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
                );
            } catch (Throwable $exception) {
                report($exception);
            }
        }
    }

    /**
     * Kirim notifikasi ke satu FCM token.
     */
    public function sendToToken(
        string $token,
        string $title,
        string $body,
    ): void {
        $message = CloudMessage::new()
            ->withToken($token)
            ->withNotification(
                Notification::create(
                    $title,
                    $body,
                )
            );

        $this->messaging()->send($message);
    }
}