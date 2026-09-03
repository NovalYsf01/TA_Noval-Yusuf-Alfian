import '../core/network/api_client.dart';

class RegistrationResult {
  const RegistrationResult({required this.success, required this.message});

  final bool success;
  final String message;
}

class RegistrationService {
  RegistrationService._internal();

  static final RegistrationService _instance = RegistrationService._internal();

  static RegistrationService get instance => _instance;

  final ApiClient _api = ApiClient.instance;

  Future<RegistrationResult> register({
    required String name,
    required String email,
    required String username,
    required String houseCode,
    required String address,
    required String phone,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      final response = await _api.post(
        '/auth/register',
        withAuth: false,
        body: {
          'name': name.trim(),
          'email': email.trim().toLowerCase(),
          'username': username.trim().toLowerCase(),
          'house_code': houseCode.trim().toUpperCase(),
          'address': address.trim(),
          'phone': phone.trim(),
          'password': password,
          'password_confirmation': passwordConfirmation,
        },
      );

      return RegistrationResult(
        success: response['success'] == true,
        message:
            response['message']?.toString() ??
            'Registrasi berhasil. Menunggu verifikasi Pengurus RT.',
      );
    } on ApiException catch (e) {
      return RegistrationResult(success: false, message: e.message);
    } catch (_) {
      return const RegistrationResult(
        success: false,
        message: 'Terjadi kesalahan. Silakan coba kembali.',
      );
    }
  }
}
