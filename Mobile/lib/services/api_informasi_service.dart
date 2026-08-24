import '../core/network/api_client.dart';
import '../models/informasi_model.dart';
import 'informasi_service.dart';

/// Implementasi [InformasiService] yang menggunakan API Laravel REST.
///
/// Endpoint yang digunakan:
///   GET /informasi        → ambil daftar informasi (mendukung pagination & parameter q)
///   GET /informasi/{id}   → ambil detail informasi spesifik
///
/// Token Bearer otomatis disertakan oleh [ApiClient].
///
/// Singleton – gunakan [ApiInformasiService.instance].
class ApiInformasiService implements InformasiService {
  ApiInformasiService._internal();

  static final ApiInformasiService _instance = ApiInformasiService._internal();

  /// Singleton instance
  static ApiInformasiService get instance => _instance;

  final _api = ApiClient.instance;

  // ─────────────────────────────────────────────────────────────────────────
  // InformasiService implementation
  // ─────────────────────────────────────────────────────────────────────────

  @override
  Future<InformasiResult> getAll({String? query, int page = 1}) async {
    try {
      final queryParams = <String, String>{
        'page': page.toString(),
      };
      
      if (query != null && query.trim().isNotEmpty) {
        queryParams['q'] = query.trim();
      }

      final body = await _api.get('/informasi', queryParams: queryParams);

      // Backend mem-wrap list di dalam field 'data'
      final data = body['data'];
      
      if (data is! List) {
        return const InformasiResult(
          success: false,
          message: 'Format respons tidak valid dari server (data bukan array).',
        );
      }

      final list = data.map((e) => InformasiModel.fromJson(e as Map<String, dynamic>)).toList();

      return InformasiResult(
        success: true,
        data: list,
        message: body['message'] as String?,
      );
    } on ApiException catch (e) {
      return InformasiResult(success: false, message: e.message);
    } catch (_) {
      return const InformasiResult(
        success: false,
        message: 'Terjadi kesalahan saat memuat daftar informasi.',
      );
    }
  }

  @override
  Future<InformasiModel?> getById(int id) async {
    try {
      final body = await _api.get('/informasi/$id');
      
      // Backend membungkus object di dalam field 'data'
      final data = body['data'] as Map<String, dynamic>?;
      if (data == null) return null;

      return InformasiModel.fromJson(data);
    } catch (_) {
      // Return null jika terjadi error network atau 404
      return null;
    }
  }
}
