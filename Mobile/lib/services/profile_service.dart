import '../core/constants/app_config.dart';
import '../models/user_model.dart';
import 'api_profile_service.dart';
import 'auth_service.dart';

/// Hasil operasi profile
class ProfileResult {
  const ProfileResult({
    required this.success,
    this.user,
    this.message,
  });

  final bool success;
  final UserModel? user;
  final String? message;
}

/// Service profil untuk aplikasi WARGA 20
///
/// Fase 3: menggunakan [ApiProfileService] (real API ke Laravel).
///
/// Endpoint:
///   GET   [AppConfig.apiBaseUrl]/profile  → getProfile()
///   PATCH [AppConfig.apiBaseUrl]/profile  → updateContact() / changePassword()
///
/// Authentication: Bearer Token via [ApiClient] (sudah otomatis).
abstract class ProfileService {
  /// Ambil data profil user yang sedang login
  Future<ProfileResult> getProfile();

  /// Update nomor telepon dan email (PATCH /profile)
  ///
  /// Hanya mengirim [phone] dan [email]. Field lain (name, username, dll.)
  /// tidak dikirim dan tidak dapat diubah dari mobile.
  Future<ProfileResult> updateContact({
    required String phone,
    required String email,
  });

  /// Ganti password (PATCH /profile)
  ///
  /// Backend membutuhkan ketiga field berikut:
  ///   current_password, password, password_confirmation
  Future<ProfileResult> changePassword({
    required String currentPassword,
    required String newPassword,
    required String passwordConfirmation,
  });

  /// Factory constructor
  ///
  /// Profile SELALU menggunakan [ApiProfileService] (real API ke Laravel).
  /// Fitur lain (Pelayanan, Informasi, dll.) menggunakan [AppConfig.useMockData].
  factory ProfileService() {
    return ApiProfileService.instance;
  }
}

/// Mock implementation — dipertahankan untuk referensi dan development offline.
///
/// Tidak lagi digunakan sebagai data source aktif sejak Fase 3.
/// MockAuthService masih ada di [auth_service.dart] dan masih bisa diakses
/// jika diperlukan untuk testing.
class MockProfileService implements ProfileService {
  MockProfileService._internal();

  static final MockProfileService _instance = MockProfileService._internal();

  // ignore: unused_element
  static MockProfileService get instance => _instance;

  /// Referensi ke singleton MockAuthService untuk sinkronisasi user session
  final _authService = MockAuthService.instance;

  @override
  Future<ProfileResult> getProfile() async {
    await Future.delayed(const Duration(milliseconds: 600));
    final user = await _authService.getCurrentUser();
    if (user != null) {
      return ProfileResult(success: true, user: user);
    }
    return const ProfileResult(
      success: false,
      message: 'Gagal memuat profil',
    );
  }

  @override
  Future<ProfileResult> updateContact({
    required String phone,
    required String email,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));
    final user = await _authService.getCurrentUser();
    if (user == null) {
      return const ProfileResult(success: false, message: 'Sesi tidak valid');
    }
    final updated = user.copyWith(phone: phone, email: email);
    await _authService.updateCurrentUser(updated);
    return ProfileResult(
      success: true,
      user: updated,
      message: 'Kontak berhasil diperbarui',
    );
  }

  @override
  Future<ProfileResult> changePassword({
    required String currentPassword,
    required String newPassword,
    required String passwordConfirmation, // diterima tapi tidak divalidasi di mock
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));
    final ok = await _authService.verifyAndChangePassword(
      currentPassword: currentPassword,
      newPassword: newPassword,
    );
    if (!ok) {
      return const ProfileResult(
        success: false,
        message: 'Password lama tidak sesuai',
      );
    }
    return const ProfileResult(
      success: true,
      message: 'Password berhasil diperbarui',
    );
  }
}
