import '../core/constants/app_config.dart';
import '../models/laporan_darurat_model.dart';
import 'api_laporan_darurat_service.dart';

/// Hasil operasi laporan darurat.
class LaporanResult {
  const LaporanResult({
    required this.success,
    this.item,
    this.message,
  });

  final bool success;
  final LaporanDaruratModel? item;
  final String? message;
}

/// Service laporan keadaan darurat RT.
///
/// Pada mode API nyata, laporan dikirim ke:
/// POST /api/v1/laporan-darurat
///
/// Authentication menggunakan Bearer Token melalui ApiClient.
abstract class LaporanDaruratService {
  Future<LaporanResult> submit({
    required EmergencyType emergencyType,
    required String description,
  });

  factory LaporanDaruratService() {
    if (AppConfig.useMockData) {
      return MockLaporanDaruratService._instance;
    }

    return ApiLaporanDaruratService.instance;
  }
}

/// Mock implementation untuk development UI.
class MockLaporanDaruratService
    implements LaporanDaruratService {
  MockLaporanDaruratService._internal();

  static final MockLaporanDaruratService _instance =
      MockLaporanDaruratService._internal();

  int _nextId = 1;

  @override
  Future<LaporanResult> submit({
    required EmergencyType emergencyType,
    required String description,
  }) async {
    await Future.delayed(
      const Duration(milliseconds: 1000),
    );

    final item = LaporanDaruratModel(
      id: _nextId++,
      emergencyType: emergencyType,
      description: description,
      reportedAt: DateTime.now(),
      status: 'diterima',
    );

    return LaporanResult(
      success: true,
      item: item,
      message:
          'Laporan keadaan darurat berhasil dikirim.',
    );
  }
}