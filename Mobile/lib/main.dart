import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:firebase_core/firebase_core.dart';

import 'services/firebase_messaging_service.dart';
import 'core/theme/app_theme.dart';
import 'screens/auth/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase Core tetap harus siap sebelum aplikasi berjalan.
  await Firebase.initializeApp();

  // Locale Bahasa Indonesia.
  await initializeDateFormatting('id', null);

  // Lock orientasi portrait.
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  // Tampilkan UI sesegera mungkin.
  runApp(const Warga20App());

  // FCM dijalankan setelah UI tampil.
  // Startup aplikasi tidak perlu menunggu request token Firebase.
  unawaited(_initializeFirebaseMessaging());
}

Future<void> _initializeFirebaseMessaging() async {
  try {
    await FirebaseMessagingService().initialize();
  } catch (e) {
    debugPrint('Firebase Messaging initialization gagal: $e');
  }
}

/// Root widget aplikasi WARGA 20
class Warga20App extends StatelessWidget {
  const Warga20App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WARGA 20',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const SplashScreen(),
    );
  }
}