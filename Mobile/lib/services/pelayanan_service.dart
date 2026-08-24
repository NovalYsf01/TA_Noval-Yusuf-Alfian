import '../core/constants/app_config.dart';
import '../models/pengajuan_pelayanan_model.dart';
import 'api_pelayanan_service.dart';

/// Hasil operasi pengajuan
class PengajuanResult {
  const PengajuanResult({required this.success, this.data, this.item, this.message});
  final bool success;
  final List<PengajuanPelayananModel>? data;
  final PengajuanPelayananModel? item;
  final String? message;
}

/// Service pelayanan administrasi RT
///
/// Saat ini menggunakan mock implementation (singleton).
/// Untuk integrasi API Laravel:
///   1. Set [AppConfig.useMockData] = false
///   2. Implementasikan ApiPelayananService dengan endpoint:
///      GET  [AppConfig.apiBaseUrl]/pelayanan          → getAll()
///      GET  [AppConfig.apiBaseUrl]/pelayanan/{id}     → getById()
///      POST [AppConfig.apiBaseUrl]/pelayanan          → submit()
///      (attachment dikirim sebagai multipart/form-data)
///   3. Kirim token Bearer di header Authorization
///
/// Catatan PDF/dokumen hasil:
///   URL dokumen hasil (result_document) mungkin berupa signed URL
///   atau route authenticated dari Laravel.
///   TODO: API/FCM INTEGRATION – implement authenticated PDF download.
///
/// TODO: API INTEGRATION – ApiPelayananService
abstract class PelayananService {
  Future<PengajuanResult> getAll();
  Future<PengajuanResult> getById(int id);
  Future<PengajuanResult> submit({
    required String purpose,
    String? description,
    String? attachmentPath,
  });

  factory PelayananService() {
    if (AppConfig.useMockData) return MockPelayananService._instance;
    return ApiPelayananService.instance;
  }
}

/// Mock implementation untuk development UI
///
/// Singleton – data pengajuan tersimpan selama sesi berlangsung.
/// Pengajuan baru dari [AjukanPelayananScreen] akan tampil di
/// [RiwayatPengajuanScreen] dan [PelayananScreen] tanpa reload.
class MockPelayananService implements PelayananService {
  MockPelayananService._internal();

  static final MockPelayananService _instance = MockPelayananService._internal();

  // In-memory repository pengajuan
  final List<PengajuanPelayananModel> _data = [
    PengajuanPelayananModel(
      id: 1,
      userId: 1,
      purpose: 'Surat Keterangan Domisili untuk keperluan administrasi bank',
      description: 'Saya memerlukan surat keterangan domisili untuk membuka rekening tabungan di bank BNI cabang terdekat.',
      status: PengajuanStatus.selesai,
      adminNote: 'Surat telah selesai diproses. Silakan ambil di rumah Ketua RT.',
      // resultDocumentDownloadUrl: null – URL akan tersedia setelah integrasi backend.
      // TODO: API INTEGRATION – URL dari endpoint /api/v1/pelayanan/{id}/dokumen-hasil.
      resultDocumentDownloadUrl: null,
      submittedAt: DateTime(2026, 8, 1),
      processedAt: DateTime(2026, 8, 3),
      completedAt: DateTime(2026, 8, 5),
    ),
    PengajuanPelayananModel(
      id: 2,
      userId: 1,
      purpose: 'Surat Pengantar SKCK untuk melamar pekerjaan',
      description: 'Membutuhkan surat pengantar dari RT untuk mengurus SKCK di Polsek guna keperluan melamar pekerjaan.',
      status: PengajuanStatus.diproses,
      adminNote: 'Surat sedang dalam proses pembuatan.',
      submittedAt: DateTime(2026, 8, 10),
      processedAt: DateTime(2026, 8, 12),
    ),
    PengajuanPelayananModel(
      id: 3,
      userId: 1,
      purpose: 'Surat Keterangan Tidak Mampu untuk beasiswa',
      description: 'Mengajukan surat keterangan tidak mampu untuk syarat pengajuan beasiswa pendidikan anak.',
      status: PengajuanStatus.menungguVerifikasi,
      submittedAt: DateTime(2026, 8, 16),
    ),
    PengajuanPelayananModel(
      id: 4,
      userId: 1,
      purpose: 'Surat Keterangan Usaha untuk UMKM',
      description: null,
      status: PengajuanStatus.ditolak,
      adminNote: 'Pengajuan ditolak karena data usaha tidak lengkap. Harap melampirkan foto tempat usaha dan mengisi deskripsi usaha secara lengkap.',
      submittedAt: DateTime(2026, 8, 5),
      processedAt: DateTime(2026, 8, 7),
    ),
  ];

  int _nextId = 5;

  @override
  Future<PengajuanResult> getAll() async {
    await Future.delayed(const Duration(milliseconds: 700));
    return PengajuanResult(
      success: true,
      data: List<PengajuanPelayananModel>.from(_data.reversed),
    );
  }

  @override
  Future<PengajuanResult> getById(int id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      final item = _data.firstWhere((e) => e.id == id);
      return PengajuanResult(success: true, item: item);
    } catch (_) {
      return const PengajuanResult(success: false, message: 'Pengajuan tidak ditemukan');
    }
  }

  @override
  Future<PengajuanResult> submit({
    required String purpose,
    String? description,
    String? attachmentPath,
  }) async {
    await Future.delayed(const Duration(milliseconds: 1200));
    final newItem = PengajuanPelayananModel(
      id: _nextId++,
      userId: 1,
      purpose: purpose,
      description: description,
      attachment: attachmentPath,
      status: PengajuanStatus.menungguVerifikasi,
      submittedAt: DateTime.now(),
    );
    _data.add(newItem);
    return PengajuanResult(
      success: true,
      item: newItem,
      message: 'Pengajuan berhasil dikirim',
    );
  }
}
