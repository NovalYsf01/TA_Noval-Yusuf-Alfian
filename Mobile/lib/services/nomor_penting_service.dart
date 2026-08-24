import '../core/constants/app_config.dart';
import '../models/nomor_penting_model.dart';
import 'api_nomor_penting_service.dart';

/// Hasil operasi nomor penting
class NomorPentingResult {
  const NomorPentingResult({required this.success, this.data, this.message});
  final bool success;
  final List<NomorPentingModel>? data;
  final String? message;
}

/// Service nomor penting RT
///
/// Saat ini menggunakan mock implementation.
/// Untuk integrasi API Laravel:
///   1. Set [AppConfig.useMockData] = false
///   2. Implementasikan ApiNomorPentingService dengan endpoint:
///      GET [AppConfig.apiBaseUrl]/nomor-penting   → getAll()
///   3. Kirim token Bearer di header Authorization
///
/// TODO: API INTEGRATION – ApiNomorPentingService
abstract class NomorPentingService {
  Future<NomorPentingResult> getAll();

  factory NomorPentingService() {
  if (AppConfig.useMockData) {
    return MockNomorPentingService._instance;
  }
  return ApiNomorPentingService.instance;
  }
}

class MockNomorPentingService implements NomorPentingService {
  MockNomorPentingService._internal();
  static final MockNomorPentingService _instance =
      MockNomorPentingService._internal();

  static final List<NomorPentingModel> _mockData = [
    NomorPentingModel(
      id: 1,
      name: 'Ketua RT 20',
      category: 'RT',
      phoneNumber: '08123456789',
      description: 'Bapak Ahmad Subagyo – Hubungi untuk urusan administrasi RT',
      isActive: true,
    ),
    NomorPentingModel(
      id: 2,
      name: 'Sekretaris RT',
      category: 'RT',
      phoneNumber: '08234567890',
      description: 'Ibu Sari Dewi – Urusan surat menyurat dan dokumen',
      isActive: true,
    ),
    NomorPentingModel(
      id: 3,
      name: 'Koordinator Keamanan',
      category: 'Keamanan',
      phoneNumber: '08345678901',
      description: 'Bapak Joko Susilo – Laporan keamanan lingkungan',
      isActive: true,
    ),
    NomorPentingModel(
      id: 4,
      name: 'Ambulans Puskesmas',
      category: 'Kesehatan',
      phoneNumber: '08456789012',
      description: 'Puskesmas Kecamatan – Layanan ambulans 24 jam',
      isActive: true,
    ),
    NomorPentingModel(
      id: 5,
      name: 'Pemadam Kebakaran',
      category: 'Darurat',
      phoneNumber: '113',
      description: 'Dinas Pemadam Kebakaran Kota – Siaga 24 jam',
      isActive: true,
    ),
    NomorPentingModel(
      id: 6,
      name: 'Kepolisian Sektor',
      category: 'Keamanan',
      phoneNumber: '110',
      description: 'Polsek setempat – Laporan tindak kejahatan',
      isActive: true,
    ),
    NomorPentingModel(
      id: 7,
      name: 'IGD Rumah Sakit',
      category: 'Kesehatan',
      phoneNumber: '08567890123',
      description: 'RS Umum terdekat – Unit Gawat Darurat',
      isActive: true,
    ),
    NomorPentingModel(
      id: 8,
      name: 'PLN (Gangguan Listrik)',
      category: 'Utilitas',
      phoneNumber: '123',
      description: 'Laporan gangguan listrik PLN',
      isActive: true,
    ),
  ];

  @override
  Future<NomorPentingResult> getAll() async {
    await Future.delayed(const Duration(milliseconds: 600));
    final activeList = _mockData.where((e) => e.isActive).toList();
    return NomorPentingResult(success: true, data: activeList);
  }
}
