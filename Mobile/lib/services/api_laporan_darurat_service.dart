import '../core/network/api_client.dart';
import '../models/laporan_darurat_model.dart';
import 'laporan_darurat_service.dart';

class ApiLaporanDaruratService implements LaporanDaruratService {
  ApiLaporanDaruratService._internal();

  static final ApiLaporanDaruratService _instance =
      ApiLaporanDaruratService._internal();

  static ApiLaporanDaruratService get instance => _instance;

  final ApiClient _api = ApiClient.instance;

  @override
  Future<LaporanResult> submit({
    required EmergencyType emergencyType,
    required String description,
  }) async {
    try {
      final response = await _api.post(
        '/laporan-darurat',
        body: {
          'emergency_type': emergencyType.apiValue,
          'description': description.trim(),
        },
      );

      final rawData = response['data'];

      if (rawData is! Map) {
        return const LaporanResult(
          success: false,
          message: 'Format respons server tidak valid.',
        );
      }

      final data = Map<String, dynamic>.from(rawData);

      final item = LaporanDaruratModel.fromJson(data);

      return LaporanResult(
        success: true,
        item: item,
        message:
            response['message']?.toString() ??
            'Laporan darurat berhasil dikirim.',
      );
    } on ApiException catch (e) {
      return LaporanResult(success: false, message: e.message);
    } catch (_) {
      return const LaporanResult(
        success: false,
        message: 'Terjadi kesalahan saat mengirim laporan darurat.',
      );
    }
  }

  @override
  Future<LaporanListResult> getMyReports({
    int page = 1,
    int perPage = 50,
  }) async {
    try {
      final response = await _api.get(
        '/laporan-darurat',
        queryParams: {'page': page.toString(), 'per_page': perPage.toString()},
      );

      final rawData = response['data'];

      if (rawData is! List) {
        return const LaporanListResult(
          success: false,
          message: 'Format riwayat laporan dari server tidak valid.',
        );
      }

      final items = rawData
          .whereType<Map>()
          .map(
            (item) =>
                LaporanDaruratModel.fromJson(Map<String, dynamic>.from(item)),
          )
          .toList();

      return LaporanListResult(
        success: true,
        items: items,
        message:
            response['message']?.toString() ??
            'Riwayat laporan berhasil dimuat.',
      );
    } on ApiException catch (e) {
      return LaporanListResult(success: false, message: e.message);
    } catch (_) {
      return const LaporanListResult(
        success: false,
        message: 'Terjadi kesalahan saat memuat riwayat laporan.',
      );
    }
  }

  @override
  Future<LaporanResult> getDetail(int id) async {
    try {
      final response = await _api.get('/laporan-darurat/$id');

      final rawData = response['data'];

      if (rawData is! Map) {
        return const LaporanResult(
          success: false,
          message: 'Format detail laporan dari server tidak valid.',
        );
      }

      final item = LaporanDaruratModel.fromJson(
        Map<String, dynamic>.from(rawData),
      );

      return LaporanResult(
        success: true,
        item: item,
        message: response['message']?.toString(),
      );
    } on ApiException catch (e) {
      return LaporanResult(success: false, message: e.message);
    } catch (_) {
      return const LaporanResult(
        success: false,
        message: 'Terjadi kesalahan saat memuat detail laporan.',
      );
    }
  }
}
