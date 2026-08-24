import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../constants/app_config.dart';

/// Penyimpanan token Sanctum menggunakan flutter_secure_storage.
///
/// Singleton – gunakan [TokenStorage.instance] untuk mengakses dari mana saja.
///
/// Key yang digunakan: [AppConfig.tokenKey] ('auth_token').
/// Token TIDAK boleh disimpan di SharedPreferences.
class TokenStorage {
  TokenStorage._internal();

  static final TokenStorage _instance = TokenStorage._internal();

  /// Singleton instance
  static TokenStorage get instance => _instance;

  // Opsi Android: enkripsi menggunakan EncryptedSharedPreferences
  static const _secureStorage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
  );

  /// Simpan access token ke secure storage.
  Future<void> saveToken(String token) async {
    await _secureStorage.write(key: AppConfig.tokenKey, value: token);
  }

  /// Ambil access token dari secure storage.
  /// Mengembalikan null jika token belum pernah disimpan atau sudah dihapus.
  Future<String?> getToken() async {
    return _secureStorage.read(key: AppConfig.tokenKey);
  }

  /// Hapus access token dari secure storage (saat logout atau token invalid).
  Future<void> deleteToken() async {
    await _secureStorage.delete(key: AppConfig.tokenKey);
  }
}
