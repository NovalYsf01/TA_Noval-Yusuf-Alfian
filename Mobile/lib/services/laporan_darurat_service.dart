import '../core/constants/app_config.dart';
import '../models/laporan_darurat_model.dart';
import 'api_laporan_darurat_service.dart';

class LaporanResult {
  const LaporanResult({required this.success, this.item, this.message});

  final bool success;
  final LaporanDaruratModel? item;
  final String? message;
}

class LaporanListResult {
  const LaporanListResult({
    required this.success,
    this.items = const [],
    this.message,
  });

  final bool success;
  final List<LaporanDaruratModel> items;
  final String? message;
}

abstract class LaporanDaruratService {
  /// Mengirim laporan baru.
  Future<LaporanResult> submit({
    required EmergencyType emergencyType,
    required String description,
  });

  /// Mengambil seluruh riwayat laporan milik
  /// warga yang sedang login.
  Future<LaporanListResult> getMyReports({int page = 1, int perPage = 50});

  /// Mengambil detail satu laporan milik warga.
  Future<LaporanResult> getDetail(int id);

  factory LaporanDaruratService() {
    if (AppConfig.useMockData) {
      return MockLaporanDaruratService._instance;
    }

    return ApiLaporanDaruratService.instance;
  }
}

class MockLaporanDaruratService implements LaporanDaruratService {
  MockLaporanDaruratService._internal();

  static final MockLaporanDaruratService _instance =
      MockLaporanDaruratService._internal();

  int _nextId = 1;

  final List<LaporanDaruratModel> _items = [];

  @override
  Future<LaporanResult> submit({
    required EmergencyType emergencyType,
    required String description,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final item = LaporanDaruratModel(
      id: _nextId++,
      emergencyType: emergencyType,
      description: description,
      reportedAt: DateTime.now(),
      status: 'waiting',
      statusLabel: 'Menunggu Penanganan',
    );

    _items.insert(0, item);

    return LaporanResult(
      success: true,
      item: item,
      message: 'Laporan keadaan darurat berhasil dikirim.',
    );
  }

  @override
  Future<LaporanListResult> getMyReports({
    int page = 1,
    int perPage = 50,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));

    return LaporanListResult(
      success: true,
      items: List.unmodifiable(_items),
      message: 'Riwayat laporan berhasil dimuat.',
    );
  }

  @override
  Future<LaporanResult> getDetail(int id) async {
    await Future.delayed(const Duration(milliseconds: 300));

    try {
      final item = _items.firstWhere((element) => element.id == id);

      return LaporanResult(success: true, item: item);
    } catch (_) {
      return const LaporanResult(
        success: false,
        message: 'Laporan tidak ditemukan.',
      );
    }
  }
}
