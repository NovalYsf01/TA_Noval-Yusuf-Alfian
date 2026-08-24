import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../constants/app_config.dart';
import 'token_storage.dart';

/// Exception yang dilempar oleh [ApiClient] ketika request gagal.
///
/// [message] selalu berisi pesan yang aman untuk ditampilkan ke user.
/// [statusCode] tersedia jika server merespons (null jika network error).
class ApiException implements Exception {
  const ApiException({required this.message, this.statusCode});

  final String message;
  final int? statusCode;

  @override
  String toString() => 'ApiException($statusCode): $message';
}

/// HTTP client terpusat untuk aplikasi WARGA 20.
///
/// Semua request ke backend Laravel harus menggunakan class ini.
/// Jangan menaruh request HTTP langsung di Widget/Page/Screen.
///
/// Fitur:
/// - Base URL dari [AppConfig.apiBaseUrl]
/// - Header Accept & Content-Type JSON otomatis
/// - Authorization: `Bearer <token>` otomatis jika token tersedia
/// - Timeout [AppConfig.connectTimeout] detik
/// - Centralized error handling → [ApiException] dengan pesan ramah
///
/// Singleton – gunakan [ApiClient.instance].
class ApiClient {
  ApiClient._internal();

  static final ApiClient _instance = ApiClient._internal();

  /// Singleton instance
  static ApiClient get instance => _instance;

  final _tokenStorage = TokenStorage.instance;
  final _client = http.Client();

  static final _baseUri = Uri.parse(AppConfig.apiBaseUrl);
  static final _timeout = Duration(seconds: AppConfig.connectTimeout);

  // ─────────────────────────────────────────────────────────────────────────
  // Internal helpers
  // ─────────────────────────────────────────────────────────────────────────

  /// Bangun headers default. Jika ada token, sertakan Authorization Bearer.
  Future<Map<String, String>> _buildHeaders({bool withAuth = true}) async {
    final headers = <String, String>{
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
    if (withAuth) {
      final token = await _tokenStorage.getToken();
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
    }
    return headers;
  }

  /// Parse body response menjadi Map.
  Map<String, dynamic> _parseBody(http.Response response) {
    try {
      return json.decode(response.body) as Map<String, dynamic>;
    } catch (_) {
      return {};
    }
  }

  /// Ambil pesan error dari body response.
  /// Prioritaskan field `message` dari backend, lalu fallback ke pesan generik.
  String _extractMessage(Map<String, dynamic> body, int statusCode) {
    // Coba ambil dari field 'message'
    if (body['message'] is String && (body['message'] as String).isNotEmpty) {
      return body['message'] as String;
    }
    // Coba ambil errors dari field 'errors' (422 validation)
    if (body['errors'] is Map) {
      final errors = body['errors'] as Map<String, dynamic>;
      final firstKey = errors.keys.first;
      final firstError = errors[firstKey];
      if (firstError is List && firstError.isNotEmpty) {
        return firstError.first.toString();
      }
    }
    return _fallbackMessage(statusCode);
  }

  String _fallbackMessage(int statusCode) {
    switch (statusCode) {
      case 401:
        return 'Username atau password salah.';
      case 403:
        return 'Akun Anda tidak memiliki akses. Hubungi Ketua RT.';
      case 422:
        return 'Data yang dimasukkan tidak valid.';
      case 429:
        return 'Terlalu banyak percobaan. Tunggu beberapa saat.';
      case 500:
      case 502:
      case 503:
        return 'Server sedang mengalami gangguan. Coba lagi nanti.';
      default:
        return 'Terjadi kesalahan. Kode: $statusCode';
    }
  }

  /// Proses response dan lempar [ApiException] jika status bukan 2xx.
  Map<String, dynamic> _handleResponse(http.Response response) {
    final body = _parseBody(response);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return body;
    }
    throw ApiException(
      message: _extractMessage(body, response.statusCode),
      statusCode: response.statusCode,
    );
  }

  /// Bungkus semua network exception menjadi [ApiException] yang ramah.
  Never _rethrowNetworkError(Object e) {
    if (e is ApiException) throw e;
    if (e is SocketException || e is http.ClientException) {
      throw const ApiException(
        message: 'Tidak dapat terhubung ke server. Periksa koneksi Wi-Fi.',
      );
    }
    if (e is TimeoutException) {
      throw const ApiException(
        message: 'Koneksi timeout. Server tidak merespons.',
      );
    }
    throw const ApiException(
      message: 'Terjadi kesalahan jaringan yang tidak terduga.',
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Public methods
  // ─────────────────────────────────────────────────────────────────────────

  /// POST request.
  ///
  /// [path] adalah path relatif dari [AppConfig.apiBaseUrl], contoh: '/auth/login'
  /// [body] adalah Map yang akan di-encode sebagai JSON.
  /// [withAuth] jika true, sertakan Authorization Bearer header (default: true).
  Future<Map<String, dynamic>> post(
    String path, {
    Map<String, dynamic>? body,
    bool withAuth = true,
  }) async {
    try {
      final uri = _baseUri.replace(path: '${_baseUri.path}$path');
      final headers = await _buildHeaders(withAuth: withAuth);
      final response = await _client
          .post(uri, headers: headers, body: body != null ? json.encode(body) : null)
          .timeout(_timeout);
      return _handleResponse(response);
    } catch (e) {
      _rethrowNetworkError(e);
    }
  }

  /// GET request.
  ///
  /// [path] adalah path relatif dari [AppConfig.apiBaseUrl], contoh: '/auth/me'
  /// [withAuth] jika true, sertakan Authorization Bearer header (default: true).
  Future<Map<String, dynamic>> get(
    String path, {
    Map<String, String>? queryParams,
    bool withAuth = true,
  }) async {
    try {
      var uri = _baseUri.replace(path: '${_baseUri.path}$path');
      if (queryParams != null && queryParams.isNotEmpty) {
        uri = uri.replace(queryParameters: queryParams);
      }
      final headers = await _buildHeaders(withAuth: withAuth);
      final response = await _client.get(uri, headers: headers).timeout(_timeout);
      return _handleResponse(response);
    } catch (e) {
      _rethrowNetworkError(e);
    }
  }

  /// PATCH request.
  ///
  /// [path] adalah path relatif dari [AppConfig.apiBaseUrl], contoh: '/profile'
  /// [body] adalah Map yang akan di-encode sebagai JSON.
  /// [withAuth] jika true, sertakan Authorization Bearer header (default: true).
  Future<Map<String, dynamic>> patch(
    String path, {
    Map<String, dynamic>? body,
    bool withAuth = true,
  }) async {
    try {
      final uri = _baseUri.replace(path: '${_baseUri.path}$path');
      final headers = await _buildHeaders(withAuth: withAuth);
      final request = http.Request('PATCH', uri)
        ..headers.addAll(headers)
        ..body = body != null ? json.encode(body) : '';
      final streamedResponse = await _client.send(request).timeout(_timeout);
      final response = await http.Response.fromStream(streamedResponse);
      return _handleResponse(response);
    } catch (e) {
      _rethrowNetworkError(e);
    }
  }

  /// POST multipart request (misal: untuk form-data upload gambar).
  ///
  /// [path] adalah path relatif dari [AppConfig.apiBaseUrl]
  /// [fields] adalah key-value string.
  /// [fileField] adalah key untuk file (misal 'attachment')
  /// [filePath] adalah lokasi file di lokal.
  Future<Map<String, dynamic>> postMultipart(
    String path, {
    Map<String, String>? fields,
    String? fileField,
    String? filePath,
    bool withAuth = true,
  }) async {
    try {
      final uri = _baseUri.replace(path: '${_baseUri.path}$path');
      final headers = await _buildHeaders(withAuth: withAuth);
      // Hapus Content-Type application/json dari default header
      headers.remove('Content-Type');

      final request = http.MultipartRequest('POST', uri)
        ..headers.addAll(headers);

      if (fields != null) {
        request.fields.addAll(fields);
      }

      if (fileField != null && filePath != null) {
        request.files.add(await http.MultipartFile.fromPath(fileField, filePath));
      }

      final streamedResponse = await _client.send(request).timeout(const Duration(seconds: 120)); // Tambah timeout untuk upload
      final response = await http.Response.fromStream(streamedResponse);
      return _handleResponse(response);
    } catch (e) {
      _rethrowNetworkError(e);
    }
  }

  /// Download file dari URL privat yang memerlukan Bearer Token.
  /// 
  /// Akan mereturn nama file yang berhasil disimpan, atau throw [ApiException].
  Future<File> downloadFile(
    String path, {
    required String savePath,
    bool withAuth = true,
  }) async {
    try {
      final uri = _baseUri.replace(path: '${_baseUri.path}$path');
      final headers = await _buildHeaders(withAuth: withAuth);
      headers.remove('Content-Type');
      headers.remove('Accept');

      final response = await _client.get(uri, headers: headers).timeout(const Duration(seconds: 120));

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final file = File(savePath);
        await file.writeAsBytes(response.bodyBytes);
        return file;
      } else {
        final body = _parseBody(response);
        throw ApiException(
          message: _extractMessage(body, response.statusCode),
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      _rethrowNetworkError(e);
    }
  }
}

