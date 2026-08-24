import '../core/network/api_client.dart';
import '../core/network/token_storage.dart';
import '../models/user_model.dart';
import 'auth_service.dart';
import 'firebase_messaging_service.dart';

import '../core/network/api_client.dart';
import '../core/network/token_storage.dart';
import '../models/user_model.dart';
import 'auth_service.dart';
import 'package:flutter/foundation.dart';



/// Implementasi [AuthService] yang menggunakan API Laravel Sanctum.
///
/// Endpoint yang digunakan:
///   POST /auth/login   → login warga
///   POST /auth/logout  → logout dan revoke token di server
///   GET  /auth/me      → validasi token dan ambil data user
///
/// Token disimpan di [TokenStorage] menggunakan flutter_secure_storage.
/// User yang sedang login disimpan di in-memory [_currentUser].
///
/// Singleton – gunakan [ApiAuthService.instance].
class ApiAuthService implements AuthService {
  ApiAuthService._internal();

  static final ApiAuthService _instance = ApiAuthService._internal();

  /// Singleton instance
  static ApiAuthService get instance => _instance;

  final _api = ApiClient.instance;
  final _tokenStorage = TokenStorage.instance;

  // In-memory state
  UserModel? _currentUser;

  // ─────────────────────────────────────────────────────────────────────────
  // AuthService implementation
  // ─────────────────────────────────────────────────────────────────────────

  @override
  Future<AuthResult> login({
    required String username,
    required String password,
  }) async {
    try {
      final body = await _api.post(
        '/auth/login',
        body: {
          'username': username,
          'password': password,
          'device_name': 'flutter-mobile',
        },
        withAuth: false, // Login tidak perlu Bearer token
      );

      // Parse response wrapper: { success, message, data: { access_token, user } }
      final data = body['data'] as Map<String, dynamic>?;
      if (data == null) {
        return const AuthResult(
          success: false,
          message: 'Respons server tidak valid.',
        );
      }

      final token = data['access_token'] as String?;
      if (token == null || token.isEmpty) {
        return const AuthResult(
          success: false,
          message: 'Token tidak ditemukan dalam respons.',
        );
      }

      // Simpan token ke secure storage
      await _tokenStorage.saveToken(token);

      try {
        await FirebaseMessagingService().registerCurrentToken();
        } catch (e) {
        // Login tetap dianggap berhasil walaupun registrasi FCM gagal
        debugPrint('Gagal menyimpan FCM token ke Laravel: $e');
      }

      // Parse user dari response
      final userJson = data['user'] as Map<String, dynamic>?;
      UserModel? user;
      if (userJson != null) {
        user = UserModel.fromJson(userJson);
        _currentUser = user;
      }

      return AuthResult(
        success: true,
        user: user,
        token: token,
        message: body['message'] as String? ?? 'Login berhasil',
      );
    } on ApiException catch (e) {
      return AuthResult(success: false, message: e.message);
    } catch (_) {
      return const AuthResult(
        success: false,
        message: 'Terjadi kesalahan yang tidak terduga.',
      );
    }
  }

  @override
  Future<bool> logout() async {
    // Selalu bersihkan lokal — bahkan jika request server gagal
    try {
      await _api.post('/auth/logout');
    } on ApiException {
      // Server tidak dapat dihubungi atau token sudah invalid — tetap lanjutkan logout lokal
    } catch (_) {
      // Ignore semua error jaringan
    } finally {
      await _tokenStorage.deleteToken();
      _currentUser = null;
    }
    return true;
  }

  @override
  Future<bool> isLoggedIn() async {
    // Cek apakah token ada di secure storage
    final token = await _tokenStorage.getToken();
    if (token == null) return false;

    // Validasi token ke server menggunakan /auth/me
    try {
      final body = await _api.get('/auth/me');
      final userJson = body['data'] as Map<String, dynamic>?;
      if (userJson != null) {
        _currentUser = UserModel.fromJson(userJson);
      }
      return true;
    } on ApiException catch (e) {
      if (e.statusCode == 401) {
        // Token tidak valid — hapus
        await _tokenStorage.deleteToken();
        _currentUser = null;
      }
      // Error lain (mis. network error) — anggap tidak login agar redirect ke Login
      return false;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    return _currentUser;
  }

  @override
  Future<void> updateCurrentUser(UserModel user) async {
    _currentUser = user;
  }
}
