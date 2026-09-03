import '../models/user_model.dart';
import 'api_profile_service.dart';
import 'auth_service.dart';

class ProfileResult {
  const ProfileResult({required this.success, this.user, this.message});

  final bool success;
  final UserModel? user;
  final String? message;
}

/// Service profil warga.
///
/// Endpoint real API:
/// GET   /profile
/// PATCH /profile
/// POST  /profile/avatar
abstract class ProfileService {
  Future<ProfileResult> getProfile();

  Future<ProfileResult> updateProfile({
    required String name,
    required String username,
    required String email,
    required String phone,
  });

  Future<ProfileResult> changePassword({
    required String currentPassword,
    required String newPassword,
    required String passwordConfirmation,
  });

  Future<ProfileResult> updateAvatar({required String filePath});

  factory ProfileService() {
    return ApiProfileService.instance;
  }
}

/// Mock implementation dipertahankan untuk development offline.
class MockProfileService implements ProfileService {
  MockProfileService._internal();

  static final MockProfileService _instance = MockProfileService._internal();

  // ignore: unused_element
  static MockProfileService get instance => _instance;

  final MockAuthService _authService = MockAuthService.instance;

  @override
  Future<ProfileResult> getProfile() async {
    await Future.delayed(const Duration(milliseconds: 500));

    final UserModel? user = await _authService.getCurrentUser();

    if (user == null) {
      return const ProfileResult(
        success: false,
        message: 'Gagal memuat profil.',
      );
    }

    return ProfileResult(
      success: true,
      user: user,
      message: 'Profil berhasil dimuat.',
    );
  }

  @override
  Future<ProfileResult> updateProfile({
    required String name,
    required String username,
    required String email,
    required String phone,
  }) async {
    await Future.delayed(const Duration(milliseconds: 600));

    final UserModel? user = await _authService.getCurrentUser();

    if (user == null) {
      return const ProfileResult(success: false, message: 'Sesi tidak valid.');
    }

    final UserModel updated = user.copyWith(
      name: name,
      username: username,
      email: email,
      phone: phone,
    );

    await _authService.updateCurrentUser(updated);

    return ProfileResult(
      success: true,
      user: updated,
      message: 'Profil berhasil diperbarui.',
    );
  }

  @override
  Future<ProfileResult> changePassword({
    required String currentPassword,
    required String newPassword,
    required String passwordConfirmation,
  }) async {
    await Future.delayed(const Duration(milliseconds: 600));

    if (newPassword != passwordConfirmation) {
      return const ProfileResult(
        success: false,
        message: 'Konfirmasi password baru tidak sesuai.',
      );
    }

    final bool success = await _authService.verifyAndChangePassword(
      currentPassword: currentPassword,
      newPassword: newPassword,
    );

    if (!success) {
      return const ProfileResult(
        success: false,
        message: 'Password saat ini tidak sesuai.',
      );
    }

    return const ProfileResult(
      success: true,
      message: 'Password berhasil diperbarui.',
    );
  }

  @override
  Future<ProfileResult> updateAvatar({required String filePath}) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final UserModel? user = await _authService.getCurrentUser();

    if (user == null) {
      return const ProfileResult(success: false, message: 'Sesi tidak valid.');
    }

    return ProfileResult(
      success: true,
      user: user,
      message: 'Foto profil berhasil diperbarui.',
    );
  }
}
