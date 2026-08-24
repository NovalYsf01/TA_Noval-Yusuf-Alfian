import '../core/network/api_client.dart';
import '../models/nomor_penting_model.dart';
import 'nomor_penting_service.dart';

/// Implementasi API nyata untuk Nomor Penting.
class ApiNomorPentingService implements NomorPentingService {
  ApiNomorPentingService._internal();

  static final ApiNomorPentingService _instance =
      ApiNomorPentingService._internal();

  static ApiNomorPentingService get instance => _instance;

  final ApiClient _api = ApiClient.instance;

  @override
  Future<NomorPentingResult> getAll() async {
    try {
      final response = await _api.get(
        '/nomor-penting',
        queryParams: {
          'per_page': '50',
        },
      );

      final dataList = response['data'] as List?;

      if (dataList == null) {
        return const NomorPentingResult(
          success: false,
          message: 'Format respons server tidak valid.',
        );
      }

      final contacts = dataList
          .whereType<Map<String, dynamic>>()
          .map((json) => NomorPentingModel.fromJson(json))
          .toList();

      return NomorPentingResult(
        success: true,
        data: contacts,
      );
    } on ApiException catch (e) {
      return NomorPentingResult(
        success: false,
        message: e.message,
      );
    } catch (e) {
      return const NomorPentingResult(
        success: false,
        message: 'Terjadi kesalahan saat memuat nomor penting.',
      );
    }
  }
}