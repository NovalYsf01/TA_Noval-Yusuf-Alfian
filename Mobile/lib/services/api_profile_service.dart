import '../core/network/api_client.dart';
import '../models/user_model.dart';
import 'profile_service.dart';

/// Implementasi [ProfileService] yang menggunakan API Laravel.
///
/// Endpoint yang digunakan:
///   GET   /profile  → ambil data profil warga
///   PATCH /profile  → update kontak (phone, email) atau ganti password
///
/// Aturan keamanan:
/// - Hanya mengirim field yang diizinkan warga ubah (phone, email, password).
/// - TIDAK mengirim: name, username, house_code, address, role, is_active, avatar_url.
/// - Token Bearer disertakan otomatis oleh [ApiClient].
///
/// Singleton – gunakan [ApiProfileService.instance].
class ApiProfileService implements ProfileService {
  ApiProfileService._internal();

  static final ApiProfileService _instance = ApiProfileService._internal();

  /// Singleton instance
  static ApiProfileService get instance => _instance;

  final _api = ApiClient.instance;

  // ─────────────────────────────────────────────────────────────────────────
  // ProfileService implementation
  // ─────────────────────────────────────────────────────────────────────────

  @override
  Future<ProfileResult> getProfile() async {
    try {
      final body = await _api.get('/profile');

      // Response wrapper: { success, message, data: { ...user fields... } }
      final data = body['data'] as Map<String, dynamic>?;
      if (data == null) {
        return const ProfileResult(
          success: false,
          message: 'Respons profil tidak valid dari server.',
        );
      }

      final user = UserModel.fromJson(data);
      return ProfileResult(
        success: true,
        user: user,
        message: body['message'] as String? ?? 'Profil berhasil dimuat.',
      );
    } on ApiException catch (e) {
      return ProfileResult(success: false, message: e.message);
    } catch (_) {
      return const ProfileResult(
        success: false,
        message: 'Terjadi kesalahan saat memuat profil.',
      );
    }
  }

  @override
  Future<ProfileResult> updateContact({
    required String phone,
    required String email,
  }) async {
    try {
      // Hanya kirim field yang diizinkan warga ubah
      final body = await _api.patch(
        '/profile',
        body: {
          'phone': phone,
          'email': email,
        },
      );

      // Setelah PATCH berhasil, fetch ulang data terbaru via GET /profile
      return await _fetchAfterUpdate(body);
    } on ApiException catch (e) {
      return ProfileResult(success: false, message: e.message);
    } catch (_) {
      return const ProfileResult(
        success: false,
        message: 'Terjadi kesalahan saat menyimpan perubahan.',
      );
    }
  }

  @override
  Future<ProfileResult> changePassword({
    required String currentPassword,
    required String newPassword,
    required String passwordConfirmation,
  }) async {
    try {
      // Kirim ke PATCH /profile sesuai kontrak backend
      final body = await _api.patch(
        '/profile',
        body: {
          'current_password': currentPassword,
          'password': newPassword,
          'password_confirmation': passwordConfirmation,
        },
      );

      return ProfileResult(
        success: true,
        message: body['message'] as String? ?? 'Password berhasil diperbarui.',
      );
    } on ApiException catch (e) {
      return ProfileResult(success: false, message: e.message);
    } catch (_) {
      return const ProfileResult(
        success: false,
        message: 'Terjadi kesalahan saat mengganti password.',
      );
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Internal helpers
  // ─────────────────────────────────────────────────────────────────────────

  /// Setelah PATCH sukses, ambil user terbaru dari response atau GET /profile.
  Future<ProfileResult> _fetchAfterUpdate(Map<String, dynamic> patchBody) async {
    // Coba ambil user dari response PATCH langsung
    final data = patchBody['data'] as Map<String, dynamic>?;
    if (data != null) {
      try {
        final user = UserModel.fromJson(data);
        return ProfileResult(
          success: true,
          user: user,
          message: patchBody['message'] as String? ?? 'Perubahan berhasil disimpan.',
        );
      } catch (_) {
        // Response data tidak bisa di-parse sebagai user — fallback ke GET
      }
    }

    // Fallback: GET /profile untuk data terbaru
    return getProfile().then((result) {
      if (result.success) {
        return ProfileResult(
          success: true,
          user: result.user,
          message: patchBody['message'] as String? ?? 'Perubahan berhasil disimpan.',
        );
      }
      // Jika GET juga gagal, tetap anggap PATCH berhasil tapi tanpa user baru
      return ProfileResult(
        success: true,
        message: patchBody['message'] as String? ?? 'Perubahan berhasil disimpan.',
      );
    });
  }
}
