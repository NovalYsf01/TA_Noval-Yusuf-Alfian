import '../core/network/api_client.dart';
import '../models/user_model.dart';
import 'auth_service.dart';
import 'profile_service.dart';

/// Implementasi ProfileService menggunakan Laravel API.
///
/// Endpoint:
/// GET   /profile
/// PATCH /profile
/// POST  /profile/avatar
///
/// Field yang boleh warga ubah:
/// - name
/// - username
/// - email
/// - phone
/// - password
/// - avatar
///
/// Field yang tidak dikirim dari mobile:
/// - house_code
/// - address
/// - role
/// - verification_status
/// - is_active
class ApiProfileService implements ProfileService {
  ApiProfileService._internal();

  static final ApiProfileService _instance = ApiProfileService._internal();

  static ApiProfileService get instance => _instance;

  final ApiClient _api = ApiClient.instance;
  final AuthService _authService = AuthService();

  @override
  Future<ProfileResult> getProfile() async {
    try {
      final Map<String, dynamic> body = await _api.get('/profile');

      final Map<String, dynamic>? data = body['data'] as Map<String, dynamic>?;

      if (data == null) {
        return const ProfileResult(
          success: false,
          message: 'Respons profil dari server tidak valid.',
        );
      }

      final UserModel user = UserModel.fromJson(data);

      await _authService.updateCurrentUser(user);

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
  Future<ProfileResult> updateProfile({
    required String name,
    required String username,
    required String email,
    required String phone,
  }) async {
    try {
      final Map<String, dynamic> body = await _api.patch(
        '/profile',
        body: {
          'name': name.trim(),
          'username': username.trim().toLowerCase(),
          'email': email.trim().toLowerCase(),
          'phone': phone.trim(),
        },
      );

      return await _resultFromResponse(
        body,
        fallbackMessage: 'Profil berhasil diperbarui.',
      );
    } on ApiException catch (e) {
      return ProfileResult(success: false, message: e.message);
    } catch (_) {
      return const ProfileResult(
        success: false,
        message: 'Terjadi kesalahan saat menyimpan profil.',
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
      final Map<String, dynamic> body = await _api.patch(
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

  @override
  Future<ProfileResult> updateAvatar({required String filePath}) async {
    try {
      final Map<String, dynamic> body = await _api.postMultipart(
        '/profile/avatar',
        fileField: 'avatar',
        filePath: filePath,
      );

      return await _resultFromResponse(
        body,
        fallbackMessage: 'Foto profil berhasil diperbarui.',
      );
    } on ApiException catch (e) {
      return ProfileResult(success: false, message: e.message);
    } catch (_) {
      return const ProfileResult(
        success: false,
        message: 'Terjadi kesalahan saat mengunggah foto profil.',
      );
    }
  }

  Future<ProfileResult> _resultFromResponse(
    Map<String, dynamic> body, {
    required String fallbackMessage,
  }) async {
    final Map<String, dynamic>? data = body['data'] as Map<String, dynamic>?;

    if (data != null) {
      try {
        final UserModel user = UserModel.fromJson(data);

        await _authService.updateCurrentUser(user);

        return ProfileResult(
          success: true,
          user: user,
          message: body['message'] as String? ?? fallbackMessage,
        );
      } catch (_) {
        // Jika data user gagal diparsing,
        // profil akan diambil ulang dari API.
      }
    }

    final ProfileResult refreshed = await getProfile();

    if (refreshed.success) {
      return ProfileResult(
        success: true,
        user: refreshed.user,
        message: body['message'] as String? ?? fallbackMessage,
      );
    }

    return ProfileResult(
      success: true,
      message: body['message'] as String? ?? fallbackMessage,
    );
  }
}
