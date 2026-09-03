import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../core/network/api_client.dart';

class FirebaseMessagingService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  final ApiClient _api = ApiClient.instance;

  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  static const String emergencyAlertChannelId = 'emergency_alert';

  static const String emergencyUpdateChannelId = 'emergency_update';

  static const String generalChannelId = 'general_notifications';

  Future<void> initialize() async {
    await _initializeLocalNotifications();

    await _createNotificationChannels();

    await _requestNotificationPermission();

    await _printCurrentToken();

    _listenTokenRefresh();

    _listenForegroundMessages();

    _listenNotificationOpened();

    await _handleInitialMessage();
  }

  Future<void> _initializeLocalNotifications() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: androidSettings);

    await _localNotifications.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        debugPrint(
          'Local notification tapped: '
          '${response.payload}',
        );

        if (response.payload != null) {
          _handleNotificationPayload(response.payload!);
        }
      },
    );
  }

  Future<void> _createNotificationChannels() async {
    final AndroidFlutterLocalNotificationsPlugin? androidPlugin =
        _localNotifications
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >();

    if (androidPlugin == null) {
      return;
    }

    final Int64List emergencyVibration = Int64List.fromList([
      0,
      700,
      250,
      700,
      250,
      1000,
    ]);

    final AndroidNotificationChannel
    emergencyAlertChannel = AndroidNotificationChannel(
      emergencyAlertChannelId,
      'Peringatan Darurat',
      description:
          'Peringatan prioritas tinggi untuk laporan darurat baru di lingkungan RT 20.',
      importance: Importance.high,
      playSound: true,
      sound: const RawResourceAndroidNotificationSound('emergency_alert'),
      enableVibration: true,
      vibrationPattern: emergencyVibration,
      showBadge: true,
      audioAttributesUsage: AudioAttributesUsage.alarm,
    );

    const AndroidNotificationChannel emergencyUpdateChannel =
        AndroidNotificationChannel(
          emergencyUpdateChannelId,
          'Pembaruan Laporan Darurat',
          description:
              'Notifikasi perubahan status dan feedback laporan darurat.',
          importance: Importance.high,
          playSound: true,
          enableVibration: true,
          showBadge: true,
        );

    const AndroidNotificationChannel generalChannel =
        AndroidNotificationChannel(
          generalChannelId,
          'Notifikasi Umum',
          description: 'Notifikasi umum aplikasi Warga 20.',
          importance: Importance.defaultImportance,
          playSound: true,
          enableVibration: true,
          showBadge: true,
        );

    await androidPlugin.createNotificationChannel(emergencyAlertChannel);

    await androidPlugin.createNotificationChannel(emergencyUpdateChannel);

    await androidPlugin.createNotificationChannel(generalChannel);

    debugPrint('Notification channels berhasil dibuat.');
  }

  Future<void> _requestNotificationPermission() async {
    final NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    debugPrint(
      'Notification permission: '
      '${settings.authorizationStatus}',
    );

    final AndroidFlutterLocalNotificationsPlugin? androidPlugin =
        _localNotifications
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >();

    if (androidPlugin != null) {
      await androidPlugin.requestNotificationsPermission();
    }
  }

  Future<void> _printCurrentToken() async {
    final String? token = await _messaging.getToken();

    debugPrint('==============================');

    debugPrint('FCM TOKEN: $token');

    debugPrint('==============================');
  }

  void _listenTokenRefresh() {
    _messaging.onTokenRefresh.listen((String newToken) async {
      try {
        await registerToken(token: newToken);
      } catch (e) {
        debugPrint(
          'FCM token refresh belum dapat '
          'dikirim ke Laravel: $e',
        );
      }
    });
  }

  void _listenForegroundMessages() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      debugPrint(
        'FCM foreground title: '
        '${message.notification?.title}',
      );

      debugPrint(
        'FCM foreground body: '
        '${message.notification?.body}',
      );

      debugPrint(
        'FCM foreground data: '
        '${message.data}',
      );

      await _showForegroundNotification(message);
    });
  }

  void _listenNotificationOpened() {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint(
        'FCM notification opened: '
        '${message.data}',
      );

      _handleRemoteMessageNavigation(message);
    });
  }

  Future<void> _handleInitialMessage() async {
    final RemoteMessage? initialMessage = await _messaging.getInitialMessage();

    if (initialMessage == null) {
      return;
    }

    debugPrint(
      'App dibuka dari FCM: '
      '${initialMessage.data}',
    );

    _handleRemoteMessageNavigation(initialMessage);
  }

  Future<void> _showForegroundNotification(RemoteMessage message) async {
    final String notificationType =
        message.data['notification_type']?.toString() ?? 'general';

    final String title =
        message.notification?.title ?? _fallbackTitle(notificationType);

    final String body = message.notification?.body ?? '';

    final NotificationDetails details = _notificationDetailsFor(
      notificationType,
    );

    final String payload = jsonEncode(message.data);

    final int notificationId = DateTime.now().millisecondsSinceEpoch.remainder(
      2147483647,
    );

    await _localNotifications.show(
      id: notificationId,
      title: title,
      body: body,
      notificationDetails: details,
      payload: payload,
    );
  }

  NotificationDetails _notificationDetailsFor(String notificationType) {
    if (notificationType == 'emergency_alert') {
      final Int64List vibrationPattern = Int64List.fromList([
        0,
        700,
        250,
        700,
        250,
        1000,
      ]);

      return NotificationDetails(
        android: AndroidNotificationDetails(
          emergencyAlertChannelId,
          'Peringatan Darurat',
          channelDescription:
              'Peringatan prioritas tinggi untuk laporan darurat baru.',
          importance: Importance.high,
          priority: Priority.max,
          playSound: true,
          sound: const RawResourceAndroidNotificationSound('emergency_alert'),
          enableVibration: true,
          vibrationPattern: vibrationPattern,
          visibility: NotificationVisibility.public,
          category: AndroidNotificationCategory.alarm,
          ticker: 'Laporan Darurat RT 20',
          styleInformation: const BigTextStyleInformation(''),
        ),
      );
    }

    if (notificationType == 'emergency_update') {
      return const NotificationDetails(
        android: AndroidNotificationDetails(
          emergencyUpdateChannelId,
          'Pembaruan Laporan Darurat',
          channelDescription: 'Perubahan status dan feedback laporan darurat.',
          importance: Importance.high,
          priority: Priority.high,
          playSound: true,
          enableVibration: true,
          visibility: NotificationVisibility.public,
        ),
      );
    }

    return const NotificationDetails(
      android: AndroidNotificationDetails(
        generalChannelId,
        'Notifikasi Umum',
        channelDescription: 'Notifikasi umum aplikasi Warga 20.',
        importance: Importance.defaultImportance,
        priority: Priority.defaultPriority,
        playSound: true,
      ),
    );
  }

  String _fallbackTitle(String notificationType) {
    switch (notificationType) {
      case 'emergency_alert':
        return '🚨 LAPORAN DARURAT RT 20';

      case 'emergency_update':
        return 'Pembaruan Laporan Darurat';

      default:
        return 'Warga 20';
    }
  }

  void _handleRemoteMessageNavigation(RemoteMessage message) {
    if (message.data.isEmpty) {
      return;
    }

    _handleNotificationPayload(jsonEncode(message.data));
  }

  void _handleNotificationPayload(String payload) {
    try {
      final Map<String, dynamic> data =
          jsonDecode(payload) as Map<String, dynamic>;

      final String? notificationType = data['notification_type']?.toString();

      final String? reportId = data['report_id']?.toString();

      debugPrint(
        'Notification payload type: '
        '$notificationType',
      );

      debugPrint(
        'Notification report ID: '
        '$reportId',
      );

      /*
       * Navigasi langsung ke detail laporan
       * akan kita sambungkan setelah
       * tampilan daftar/detail laporan darurat
       * diperbarui pada fase berikutnya.
       */
    } catch (e) {
      debugPrint('Payload notification tidak valid: $e');
    }
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

  Future<void> registerToken({required String token}) async {
    await _api.post(
      '/device-token',
      body: {'token': token, 'platform': 'android'},
    );

    debugPrint(
      'FCM TOKEN BERHASIL '
      'DISIMPAN KE LARAVEL',
    );
  }
}
