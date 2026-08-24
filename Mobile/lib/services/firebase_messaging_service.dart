import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

import '../core/network/api_client.dart';

class FirebaseMessagingService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final ApiClient _api = ApiClient.instance;

  Future<void> initialize() async {
    // Minta izin notifikasi
    final NotificationSettings settings =
        await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    debugPrint(
      'Notification permission: ${settings.authorizationStatus}',
    );

    // Ambil token FCM
    final String? token = await _messaging.getToken();

    debugPrint('==============================');
    debugPrint('FCM TOKEN: $token');
    debugPrint('==============================');

    // Jika token Firebase berubah, coba simpan token baru ke Laravel.
    // Bila user belum login, kegagalan diabaikan.
    _messaging.onTokenRefresh.listen((String newToken) async {
      try {
        await registerToken(token: newToken);
      } catch (e) {
        debugPrint(
          'FCM token refresh belum dapat dikirim ke Laravel: $e',
        );
      }
    });

    // Notifikasi diterima saat aplikasi sedang terbuka
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint(
        'Notification received: ${message.notification?.title}',
      );

      debugPrint(
        'Notification body: ${message.notification?.body}',
      );
    });

    // Ketika aplikasi dibuka melalui notifikasi
    FirebaseMessaging.onMessageOpenedApp.listen(
      (RemoteMessage message) {
        debugPrint(
          'Notification opened: ${message.notification?.title}',
        );
      },
    );
  }

  /// Dipanggil setelah login berhasil.
  Future<void> registerCurrentToken() async {
    final String? token = await _messaging.getToken();

    if (token == null || token.isEmpty) {
      debugPrint('FCM token tidak tersedia.');
      return;
    }

    await registerToken(token: token);
  }

  Future<void> registerToken({
    required String token,
  }) async {
    await _api.post(
      '/device-token',
      body: {
        'token': token,
        'platform': 'android',
      },
    );

    debugPrint('FCM TOKEN BERHASIL DISIMPAN KE LARAVEL');
  }
}