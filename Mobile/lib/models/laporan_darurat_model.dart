/// Tipe laporan darurat
///
/// Nilai enum Dart menggunakan Bahasa Indonesia untuk keterbacaan kode.
/// Label UI tetap Bahasa Indonesia.
/// apiValue disesuaikan dengan EmergencyType backend (English):
///
///   Backend value         Flutter enum
///   ──────────────────────────────────────
///   fire               → kebakaran
///   illness_or_accident→ sakitKecelakaan
///   theft              → pencurian
///   crime              → tindakKejahatan
///   death              → kematian
///   other              → lainnya
///
/// Backend mengirim emergency_type sebagai object:
///   { "code": "fire", "label": "Kebakaran" }
/// Parsing menggunakan [fromBackendCode] dari field "code".
enum EmergencyType {
  kebakaran,
  sakitKecelakaan,
  pencurian,
  tindakKejahatan,
  kematian,
  lainnya;

  /// Label Bahasa Indonesia untuk ditampilkan di UI
  String get label {
    switch (this) {
      case EmergencyType.kebakaran:
        return 'Kebakaran';
      case EmergencyType.sakitKecelakaan:
        return 'Sakit / Kecelakaan';
      case EmergencyType.pencurian:
        return 'Pencurian';
      case EmergencyType.tindakKejahatan:
        return 'Tindak Kejahatan';
      case EmergencyType.kematian:
        return 'Kematian';
      case EmergencyType.lainnya:
        return 'Lainnya';
    }
  }

  /// Nilai yang dikirim ke API backend (English, sesuai EmergencyType enum Laravel)
  String get apiValue {
    switch (this) {
      case EmergencyType.kebakaran:
        return 'fire';
      case EmergencyType.sakitKecelakaan:
        return 'illness_or_accident';
      case EmergencyType.pencurian:
        return 'theft';
      case EmergencyType.tindakKejahatan:
        return 'crime';
      case EmergencyType.kematian:
        return 'death';
      case EmergencyType.lainnya:
        return 'other';
    }
  }

  /// Parse dari code backend (English).
  /// Backend mengirim emergency_type sebagai object { "code": "...", "label": "..." }.
  /// Gunakan metode ini dengan nilai dari emergency_type["code"].
  static EmergencyType fromBackendCode(String code) {
    switch (code.toLowerCase()) {
      case 'fire':
        return EmergencyType.kebakaran;
      case 'illness_or_accident':
        return EmergencyType.sakitKecelakaan;
      case 'theft':
        return EmergencyType.pencurian;
      case 'crime':
        return EmergencyType.tindakKejahatan;
      case 'death':
        return EmergencyType.kematian;
      default:
        return EmergencyType.lainnya;
    }
  }

  /// Parse dari string (untuk kompatibilitas MockService).
  /// Mendukung nilai English maupun Bahasa Indonesia.
  static EmergencyType fromString(String value) {
    switch (value.toLowerCase()) {
      // English (backend canonical values)
      case 'fire':
        return EmergencyType.kebakaran;
      case 'illness_or_accident':
        return EmergencyType.sakitKecelakaan;
      case 'theft':
        return EmergencyType.pencurian;
      case 'crime':
        return EmergencyType.tindakKejahatan;
      case 'death':
        return EmergencyType.kematian;
      case 'other':
        return EmergencyType.lainnya;
      // Bahasa Indonesia (nilai internal mock lama — backward compat)
      case 'kebakaran':
        return EmergencyType.kebakaran;
      case 'sakit_kecelakaan':
        return EmergencyType.sakitKecelakaan;
      case 'pencurian':
        return EmergencyType.pencurian;
      case 'tindak_kejahatan':
        return EmergencyType.tindakKejahatan;
      case 'kematian':
        return EmergencyType.kematian;
      default:
        return EmergencyType.lainnya;
    }
  }
}

/// Model laporan darurat
///
/// Field mapping vs EmergencyReportResource backend:
///   id            ← id
///   emergencyType ← emergency_type.code  (backend kirim object {code, label})
///   description   ← description
///   reportedAt    ← reported_at
///
/// CATATAN: Backend tidak memiliki field status untuk laporan darurat.
/// Field [status] dipertahankan hanya untuk kompatibilitas MockService
/// dan tidak akan diisi dari response API backend.
class LaporanDaruratModel {
  const LaporanDaruratModel({
    required this.id,
    required this.emergencyType,
    required this.description,
    required this.reportedAt,
    this.status,
  });

  final int id;
  final EmergencyType emergencyType;
  final String description;
  final DateTime reportedAt;

  /// Status internal — HANYA digunakan oleh MockService.
  /// Backend tidak mengirim field ini; nilai dari API selalu null.
  /// Jangan diisi atau dibaca dari response backend.
  final String? status;

  factory LaporanDaruratModel.fromJson(Map<String, dynamic> json) {
    // Backend mengirim emergency_type sebagai object: { "code": "...", "label": "..." }
    final typeRaw = json['emergency_type'];
    final EmergencyType emergencyType;
    if (typeRaw is Map<String, dynamic>) {
      emergencyType = EmergencyType.fromBackendCode(
          typeRaw['code'] as String? ?? 'other');
    } else if (typeRaw is String) {
      // Fallback jika string langsung
      emergencyType = EmergencyType.fromString(typeRaw);
    } else {
      emergencyType = EmergencyType.lainnya;
    }

    return LaporanDaruratModel(
      id: json['id'] as int,
      emergencyType: emergencyType,
      description: json['description'] as String,
      reportedAt: DateTime.parse(json['reported_at'] as String),
      // status tidak dikirim backend — selalu null dari API
      status: null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'emergency_type': emergencyType.apiValue,
      'description': description,
      'reported_at': reportedAt.toIso8601String(),
    };
  }
}
