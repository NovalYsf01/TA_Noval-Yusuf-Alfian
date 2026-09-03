import 'package:flutter/foundation.dart';

import '../core/network/api_client.dart';
import '../core/network/token_storage.dart';
import '../models/user_model.dart';
import 'auth_service.dart';
import 'firebase_messaging_service.dart';

/// Implementasi [AuthService] yang menggunakan API Laravel Sanctum.
///
/// Endpoint yang digunakan:
/// - POST /auth/login
/// - POST /auth/logout
/// - GET /auth/me
///
/// Token disimpan melalui [TokenStorage].
/// User yang sedang login disimpan sementara di [_currentUser].
///
/// Gunakan singleton [ApiAuthService.instance].
class ApiAuthService implements AuthService {
  ApiAuthService._internal();

  static final ApiAuthService _instance = ApiAuthService._internal();

  static ApiAuthService get instance => _instance;

  final ApiClient _api = ApiClient.instance;
  final TokenStorage _tokenStorage = TokenStorage.instance;

  UserModel? _currentUser;

  @override
  Future<AuthResult> login({
    required String username,
    required String password,
  }) async {
    try {
      final Map<String, dynamic> body = await _api.post(
        '/auth/login',
        body: {
          'username': username.trim(),
          'password': password,
          'device_name': 'flutter-mobile',
        },
        withAuth: false,
      );

      final Map<String, dynamic>? data = body['data'] as Map<String, dynamic>?;

      if (data == null) {
        return const AuthResult(
          success: false,
          message: 'Respons server tidak valid.',
        );
      }

      final String? token = data['access_token'] as String?;

      if (token == null || token.isEmpty) {
        return const AuthResult(
          success: false,
          message: 'Token tidak ditemukan dalam respons.',
        );
      }

      await _tokenStorage.saveToken(token);

      try {
        await FirebaseMessagingService().registerCurrentToken();
      } catch (e) {
        debugPrint('Gagal menyimpan FCM token ke Laravel: $e');
      }

      final Map<String, dynamic>? userJson =
          data['user'] as Map<String, dynamic>?;

      UserModel? user;

      if (userJson != null) {
        user = UserModel.fromJson(userJson);
        _currentUser = user;
      }

      return AuthResult(
        success: true,
        user: user,
        token: token,
        message: body['message'] as String? ?? 'Login berhasil.',
      );
    } on ApiException catch (e) {
      return AuthResult(success: false, message: e.message);
    } catch (e) {
      debugPrint('Login error: $e');

      return const AuthResult(
        success: false,
        message: 'Terjadi kesalahan yang tidak terduga.',
      );
    }
  }

  @override
  Future<bool> logout() async {
    try {
      await _api.post('/auth/logout');
    } on ApiException catch (e) {
      debugPrint('Logout API error: ${e.message}');
    } catch (e) {
      debugPrint('Logout network error: $e');
    } finally {
      await _tokenStorage.deleteToken();
      _currentUser = null;
    }

    return true;
  }

  @override
  Future<bool> isLoggedIn() async {
    final String? token = await _tokenStorage.getToken();

    if (token == null || token.isEmpty) {
      return false;
    }

    try {
      final Map<String, dynamic> body = await _api.get('/auth/me');

      final Map<String, dynamic>? userJson =
          body['data'] as Map<String, dynamic>?;

      if (userJson != null) {
        _currentUser = UserModel.fromJson(userJson);
      }

      return true;
    } on ApiException catch (e) {
      if (e.statusCode == 401) {
        await _tokenStorage.deleteToken();
        _currentUser = null;
      }

      return false;
    } catch (e) {
      debugPrint('Validasi sesi error: $e');

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
