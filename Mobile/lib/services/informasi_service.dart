import '../core/constants/app_config.dart';
import '../models/informasi_model.dart';
import 'api_informasi_service.dart';

/// Hasil operasi informasi
class InformasiResult {
  const InformasiResult({required this.success, this.data, this.message});
  final bool success;
  final List<InformasiModel>? data;
  final String? message;
}

/// Service informasi/pengumuman RT
///
/// Saat ini menggunakan mock implementation.
/// Untuk integrasi API Laravel:
///   1. Set [AppConfig.useMockData] = false
///   2. Implementasikan ApiInformasiService dengan endpoint:
///      GET [AppConfig.apiBaseUrl]/informasi        → getAll()
///      GET [AppConfig.apiBaseUrl]/informasi/{id}   → getById()
///   3. Kirim token Bearer di header Authorization
///
/// Catatan model: field [InformasiModel.category] bersifat optional.
/// Jika API tidak mengirim category, default 'Umum' akan digunakan.
///
/// TODO: API INTEGRATION – ApiInformasiService
abstract class InformasiService {
  Future<InformasiResult> getAll({String? query, int page = 1});
  Future<InformasiModel?> getById(int id);

  factory InformasiService() {
    return ApiInformasiService.instance;
  }
}

class MockInformasiService implements InformasiService {
  MockInformasiService._internal();
  // ignore: unused_field
  static final MockInformasiService _instance = MockInformasiService._internal();

  static final List<InformasiModel> _mockData = [
    InformasiModel(
      id: 1,
      title: 'Jadwal Kerja Bakti Lingkungan RT 20',
      content:
          'Warga RT 20 yang terhormat,\n\nBersama ini kami mengumumkan bahwa akan diadakan kegiatan Kerja Bakti Lingkungan pada:\n\nHari/Tanggal: Minggu, 25 Agustus 2026\nWaktu: Pukul 07.00 – 11.00 WIB\nTempat: Area lingkungan RT 20\n\nKegiatan meliputi:\n- Pembersihan selokan dan got\n- Pengecatan ulang tembok batas RT\n- Penanaman pohon penghijauan\n- Pembersihan area taman\n\nDiharapkan seluruh warga dapat berpartisipasi aktif demi kebersihan dan keindahan lingkungan kita bersama.\n\nMohon membawa peralatan kebersihan masing-masing.\n\nHormat kami,\nKetua RT 20',
      category: 'Pengumuman',
      publishedAt: DateTime(2026, 8, 18),
    ),
    InformasiModel(
      id: 2,
      title: 'Pengumuman Kebersihan Lingkungan',
      content:
          'Kepada Bapak/Ibu Warga RT 20,\n\nDalam rangka menjaga kebersihan dan keindahan lingkungan, kami mengingatkan beberapa hal penting:\n\n1. Buang sampah pada tempatnya dan sesuai jadwal pengangkutan\n2. Jangan membuang sampah di selokan atau area umum\n3. Pisahkan sampah organik dan anorganik\n4. Jaga kebersihan depan rumah masing-masing\n\nJadwal pengangkutan sampah:\n- Senin, Rabu, Jumat: Pukul 06.00 – 08.00 WIB\n\nMari kita jaga lingkungan RT 20 tetap bersih dan asri bersama-sama.\n\nHormat kami,\nKetua RT 20',
      category: 'Pengumuman',
      publishedAt: DateTime(2026, 8, 15),
    ),
    InformasiModel(
      id: 3,
      title: 'Kegiatan Posyandu Balita Agustus 2026',
      content:
          'Kepada Bapak/Ibu Warga RT 20,\n\nKami menginformasikan bahwa Posyandu Balita bulan Agustus 2026 akan dilaksanakan pada:\n\nHari/Tanggal: Rabu, 20 Agustus 2026\nWaktu: Pukul 08.00 – 11.00 WIB\nTempat: Balai RT 20\n\nKegiatan meliputi:\n- Penimbangan berat badan\n- Pengukuran tinggi badan\n- Imunisasi (sesuai jadwal)\n- Pemberian vitamin A\n- Konsultasi gizi\n\nDiharapkan seluruh ibu yang memiliki balita dapat hadir tepat waktu.\nHarap membawa buku KIA/KMS anak.\n\nSalam sehat,\nKader Posyandu RT 20',
      category: 'Kesehatan',
      publishedAt: DateTime(2026, 8, 12),
    ),
    InformasiModel(
      id: 4,
      title: 'Rapat Warga RT 20',
      content:
          'Kepada seluruh warga RT 20,\n\nDengan ini kami mengundang Bapak/Ibu untuk hadir dalam Rapat Warga yang akan membahas rencana kegiatan dan perbaikan fasilitas lingkungan RT 20.\n\nHari/Tanggal: Sabtu, 23 Agustus 2026\nWaktu: Pukul 19.30 WIB (Setelah Isya)\nTempat: Rumah Ketua RT\n\nAgenda:\n1. Pembukaan\n2. Evaluasi kegiatan bulan lalu\n3. Rencana pengaspalan jalan\n4. Rencana pembuatan pos keamanan\n5. Lain-lain\n\nMohon kehadiran Bapak/Ibu, satu KK minimal satu perwakilan.\n\nHormat kami,\nKetua RT 20',
      category: 'Kegiatan',
      publishedAt: DateTime(2026, 8, 10),
    ),
    InformasiModel(
      id: 5,
      title: 'Informasi Keamanan Lingkungan',
      content:
          'Kepada seluruh warga RT 20,\n\nSehubungan dengan pentingnya menjaga keamanan lingkungan, kami mengimbau seluruh warga untuk:\n\n1. Selalu mengunci pintu dan jendela rumah\n2. Memasang lampu di depan rumah (terutama malam hari)\n3. Aktif dalam ronda malam sesuai jadwal\n4. Segera melapor jika melihat orang mencurigakan\n5. Tidak mempublikasikan jadwal bepergian di media sosial\n\nJadwal ronda:\n- Senin-Rabu: Kelompok A (19.00 – 23.00)\n- Kamis-Sabtu: Kelompok B (19.00 – 23.00)\n- Minggu: Kelompok C (19.00 – 23.00)\n\nMari jaga keamanan lingkungan kita bersama!\n\nSalam aman,\nKoordinator Keamanan RT 20',
      category: 'Keamanan',
      publishedAt: DateTime(2026, 8, 8),
    ),
    InformasiModel(
      id: 6,
      title: 'Program Pendataan Warga KIS/BPJS',
      content:
          'Kepada warga RT 20 yang terhormat,\n\nSesuai dengan program pemerintah, kami membuka pendataan warga yang membutuhkan bantuan Kartu Indonesia Sehat (KIS) / BPJS Kesehatan.\n\nSyarat pendaftaran:\n1. KTP dan KK\n2. Surat Keterangan dari RT\n3. Pas foto 3x4 (2 lembar)\n\nPendaftaran dibuka mulai:\n- Tanggal: 18 – 28 Agustus 2026\n- Waktu: Pukul 09.00 – 15.00 WIB\n- Tempat: Rumah Ketua RT / hubungi sekretaris RT\n\nInformasi lebih lanjut: hubungi Ketua RT.\n\nTerima kasih.',
      category: 'Pengumuman',
      publishedAt: DateTime(2026, 8, 5),
    ),
  ];

  @override
  Future<InformasiResult> getAll({String? query, int page = 1}) async {
    await Future.delayed(const Duration(milliseconds: 900));
    
    var data = _mockData;
    if (query != null && query.isNotEmpty) {
      final q = query.toLowerCase();
      data = data.where((e) => e.title.toLowerCase().contains(q) || e.content.toLowerCase().contains(q)).toList();
    }
    return InformasiResult(success: true, data: List.unmodifiable(data));
  }

  @override
  Future<InformasiModel?> getById(int id) async {
    await Future.delayed(const Duration(milliseconds: 400));
    try {
      return _mockData.firstWhere((e) => e.id == id);
    } catch (_) {
      return null;
    }
  }
}
