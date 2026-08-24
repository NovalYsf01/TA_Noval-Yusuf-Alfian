import '../models/user_model.dart';
import 'api_auth_service.dart';


/// Hasil operasi autentikasi
class AuthResult {
  const AuthResult({
    required this.success,
    this.user,
    this.token,
    this.message,
  });

  final bool success;
  final UserModel? user;
  final String? token;
  final String? message;
}

/// Service autentikasi untuk aplikasi WARGA 20
///
/// Saat ini menggunakan mock implementation (singleton).
/// Untuk integrasi API Laravel:
///   1. Set [AppConfig.useMockData] = false
///   2. Implementasikan ApiAuthService dengan endpoint:
///      POST [AppConfig.apiBaseUrl]/auth/login
///      POST [AppConfig.apiBaseUrl]/auth/logout
///      GET  [AppConfig.apiBaseUrl]/auth/me
///   3. Simpan token ke FlutterSecureStorage (key: AppConfig.tokenKey)
///   4. Kirim token sebagai Bearer di header Authorization
///
/// TODO: API INTEGRATION – ApiAuthService
abstract class AuthService {
  /// Login dengan username dan password
  Future<AuthResult> login({
    required String username,
    required String password,
  });

  /// Logout dan hapus session
  Future<bool> logout();

  /// Cek apakah user sudah login (ada token valid)
  Future<bool> isLoggedIn();

  /// Ambil data user yang sedang login
  Future<UserModel?> getCurrentUser();

  /// Update user di session (digunakan oleh ProfileService setelah update)
  Future<void> updateCurrentUser(UserModel user);

  /// Factory constructor
  ///
  /// Auth SELALU menggunakan [ApiAuthService] (real API ke Laravel Sanctum).
  /// Fitur lain (Pelayanan, Informasi, dll.) menggunakan [AppConfig.useMockData].
  factory AuthService() {
    return ApiAuthService.instance;
  }
}

/// Mock implementation untuk development UI
///
/// Menggunakan singleton agar session konsisten di seluruh screen:
///   Splash → Login → Home → Profile → Logout
///
/// Credentials demo: username=warga01 / password=123456
class MockAuthService implements AuthService {
  MockAuthService._internal();

  /// Singleton instance – gunakan ini untuk mengakses session dari service lain.
  // ignore: library_private_types_in_public_api
  static final MockAuthService _instance = MockAuthService._internal();

  /// Public accessor untuk digunakan service lain (ProfileService)
  static MockAuthService get instance => _instance;

  // In-memory session
  String? _token;
  UserModel? _currentUser;
  String _mockPassword = '123456'; // dapat diupdate oleh changePassword

  // Data mock warga (default)
  static const _defaultUser = UserModel(
    id: 1,
    username: 'warga01',
    name: 'Budi Santoso',
    address: 'Jl. Mawar No. 5, RT 20',
    phone: '08123456789',
    email: 'budi.santoso@email.com',
    role: 'warga',
    isActive: true,
  );

  @override
  Future<AuthResult> login({
    required String username,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 1200));

    if (username == _defaultUser.username && password == _mockPassword) {
      _token = 'mock_token_${DateTime.now().millisecondsSinceEpoch}';
      _currentUser = _defaultUser;
      return AuthResult(
        success: true,
        user: _currentUser,
        token: _token,
        message: 'Login berhasil',
      );
    }

    return const AuthResult(
      success: false,
      message: 'Username atau password salah',
    );
  }

  @override
  Future<bool> logout() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _token = null;
    _currentUser = null;
    return true;
  }

  @override
  Future<bool> isLoggedIn() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _token != null;
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    return _currentUser;
  }

  @override
  Future<void> updateCurrentUser(UserModel user) async {
    _currentUser = user;
  }

  /// Verifikasi password lama dan update password mock session
  Future<bool> verifyAndChangePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    if (currentPassword != _mockPassword) return false;
    _mockPassword = newPassword;
    return true;
  }
}
