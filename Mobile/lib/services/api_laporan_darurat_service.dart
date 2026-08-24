import '../core/network/api_client.dart';
import '../models/laporan_darurat_model.dart';
import 'laporan_darurat_service.dart';

/// Implementasi API nyata untuk laporan keadaan darurat.
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

      if (rawData is! Map<String, dynamic>) {
        return const LaporanResult(
          success: false,
          message: 'Format respons server tidak valid.',
        );
      }

      final rawEmergencyType = rawData['emergency_type'];

      String emergencyCode = emergencyType.apiValue;

      if (rawEmergencyType is Map) {
        final rawCode = rawEmergencyType['code'];
        if (rawCode != null) {
          emergencyCode = rawCode.toString();
        }
      }

      final rawId = rawData['id'];

      final int id = rawId is int
          ? rawId
          : int.tryParse(rawId?.toString() ?? '') ?? 0;

      final reportedAt =
          DateTime.tryParse(rawData['reported_at']?.toString() ?? '') ??
              DateTime.now();

      final item = LaporanDaruratModel(
        id: id,
        emergencyType:
            EmergencyType.fromBackendCode(emergencyCode),
        description:
            rawData['description']?.toString() ?? description.trim(),
        reportedAt: reportedAt,

        // Hanya untuk kompatibilitas model Flutter lama.
        // Backend laporan darurat tidak memiliki workflow status.
        status: 'diterima',
      );

      return LaporanResult(
        success: true,
        item: item,
        message: response['message']?.toString() ??
            'Laporan darurat berhasil dikirim.',
      );
    } on ApiException catch (e) {
      return LaporanResult(
        success: false,
        message: e.message,
      );
    } catch (_) {
      return const LaporanResult(
        success: false,
        message: 'Terjadi kesalahan saat mengirim laporan darurat.',
      );
    }
  }
}