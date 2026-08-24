import 'package:flutter/material.dart';

/// Palet warna utama aplikasi WARGA 20
class AppColors {
  AppColors._();

  // Primary – Biru Tua RT
  static const Color primary = Color(0xFF1A56DB);
  static const Color primaryDark = Color(0xFF1240B0);
  static const Color primaryLight = Color(0xFF3D74F4);
  static const Color primarySurface = Color(0xFFEBF1FE);

  // Accent – Hijau Sukses
  static const Color accent = Color(0xFF0E9F6E);
  static const Color accentLight = Color(0xFFD1FAE5);

  // Warning – Kuning
  static const Color warning = Color(0xFFF59E0B);
  static const Color warningLight = Color(0xFFFEF3C7);

  // Danger – Merah Darurat
  static const Color danger = Color(0xFFE02424);
  static const Color dangerLight = Color(0xFFFDE8E8);

  // Neutral
  static const Color white = Color(0xFFFFFFFF);
  static const Color background = Color(0xFFF5F7FA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color border = Color(0xFFE5E7EB);
  static const Color divider = Color(0xFFF3F4F6);

  // Text
  static const Color textPrimary = Color(0xFF111827);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textHint = Color(0xFF9CA3AF);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // Gradient primary
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1A56DB), Color(0xFF3D74F4)],
  );

  // Gradient header beranda
  static const LinearGradient headerGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1240B0), Color(0xFF1A56DB), Color(0xFF3D74F4)],
  );
}
