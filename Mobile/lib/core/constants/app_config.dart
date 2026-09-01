/// Konfigurasi terpusat aplikasi WARGA 20
///
/// ─────────────────────────────────────────────────────────────────────────
/// UNTUK DEVELOPER BACKEND / INTEGRATION:
///
/// Isi [apiBaseUrl] dengan URL server Laravel setelah endpoint tersedia.
/// JANGAN hardcode URL production di masing-masing screen/service.
/// Semua request HTTP harus menggunakan [apiBaseUrl] sebagai base.
///
/// Expected API Endpoints (Laravel REST API):
///   POST   /auth/login                → AuthService.login()
///   POST   /auth/logout               → AuthService.logout()
///   GET    /auth/me                   → AuthService.getCurrentUser()
///
///   GET    /profile                   → ProfileService.getProfile()
///   PATCH  /profile                   → ProfileService.updateContact()
///
///   GET    /informasi                 → InformasiService.getAll()
///   GET    /informasi/{id}            → InformasiService.getById()
///
///   GET    /pelayanan                 → PelayananService.getAll()
///   POST   /pelayanan                 → PelayananService.submit() [multipart]
///   GET    /pelayanan/{id}            → PelayananService.getById()
///
///   GET    /laporan-darurat           → (future)
///   POST   /laporan-darurat           → LaporanDaruratService.submit()
///   GET    /laporan-darurat/{id}      → (future)
///
///   GET    /nomor-penting             → NomorPentingService.getAll()
///
///   POST   /device-token              → TODO: FCM INTEGRATION
///   DELETE /device-token              → TODO: FCM INTEGRATION
///
/// Authentication: Bearer Token
///   Header: Authorization: Bearer `{token}`
///   Token disimpan di FlutterSecureStorage dengan key [tokenKey]
/// ─────────────────────────────────────────────────────────────────────────
class AppConfig {
  AppConfig._();

  // Base URL server Laravel (development / lokal).
  // GANTI nilai ini jika IP laptop berubah — cukup dari satu tempat ini.
  // Format: 'http://<IP_LAPTOP>:<PORT>/api/v1'
  static const String apiBaseUrl =  'https://noval.djncloud.my.id/api/v1';

  // Request timeout (detik)
  static const int connectTimeout = 30;
  static const int receiveTimeout = 30;

  // Storage keys
  static const String tokenKey = 'auth_token';
  static const String userKey = 'user_data';

  // App info
  static const String appVersion = '1.0.0';
  static const String appName = 'Warga 20';

  /// Mode development – mock data aktif saat true.
  /// Fitur selain auth (Pelayanan, Informasi, dll.) menggunakan mock selama flag ini true.
  ///
  /// CATATAN: Auth (login, logout, /auth/me) SELALU menggunakan API nyata,
  /// tidak bergantung pada flag ini.
  static const bool useMockData = false;
}
