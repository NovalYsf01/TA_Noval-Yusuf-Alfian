/// Jenis keadaan darurat.
enum EmergencyType {
  kebakaran,
  sakitKecelakaan,
  pencurian,
  tindakKejahatan,
  kematian,
  lainnya;

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
      case 'other':
      default:
        return EmergencyType.lainnya;
    }
  }

  static EmergencyType fromString(String value) {
    switch (value.toLowerCase()) {
      case 'fire':
      case 'kebakaran':
        return EmergencyType.kebakaran;

      case 'illness_or_accident':
      case 'sakit_kecelakaan':
        return EmergencyType.sakitKecelakaan;

      case 'theft':
      case 'pencurian':
        return EmergencyType.pencurian;

      case 'crime':
      case 'tindak_kejahatan':
        return EmergencyType.tindakKejahatan;

      case 'death':
      case 'kematian':
        return EmergencyType.kematian;

      default:
        return EmergencyType.lainnya;
    }
  }
}

/// Model laporan keadaan darurat warga.
///
/// Nilai status backend:
/// - waiting     = Menunggu Penanganan
/// - in_progress = Sedang Ditangani
/// - resolved    = Selesai
class LaporanDaruratModel {
  const LaporanDaruratModel({
    required this.id,
    required this.emergencyType,
    required this.description,
    required this.reportedAt,
    this.status = 'waiting',
    this.statusLabel = 'Menunggu Penanganan',
    this.feedback,
    this.evidencePhotoPath,
    this.evidencePhotoUrl,
    this.handledById,
    this.handledByName,
    this.handledAt,
    this.resolvedAt,
    this.archivedAt,
    this.createdAt,
    this.updatedAt,
  });

  final int id;
  final EmergencyType emergencyType;
  final String description;

  /// Canonical status code dari backend.
  final String status;

  /// Label Bahasa Indonesia dari backend.
  final String statusLabel;

  /// Feedback / catatan penanganan dari Pengurus RT.
  final String? feedback;

  /// Path internal file pada storage Laravel.
  final String? evidencePhotoPath;

  /// URL foto bukti yang dapat ditampilkan mobile.
  final String? evidencePhotoUrl;

  /// Pengurus RT yang menangani laporan.
  final int? handledById;
  final String? handledByName;

  final DateTime? handledAt;
  final DateTime? resolvedAt;
  final DateTime? archivedAt;

  final DateTime reportedAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  bool get isWaiting => status == 'waiting';

  bool get isInProgress => status == 'in_progress';

  bool get isResolved => status == 'resolved';

  bool get isArchived => archivedAt != null;

  bool get hasFeedback => feedback != null && feedback!.trim().isNotEmpty;

  bool get hasEvidencePhoto =>
      evidencePhotoUrl != null && evidencePhotoUrl!.trim().isNotEmpty;

  factory LaporanDaruratModel.fromJson(Map<String, dynamic> json) {
    final rawEmergencyType = json['emergency_type'];

    String emergencyCode = 'other';

    if (rawEmergencyType is Map) {
      emergencyCode = rawEmergencyType['code']?.toString() ?? 'other';
    } else if (rawEmergencyType != null) {
      emergencyCode = rawEmergencyType.toString();
    }

    final rawStatus = json['status'];

    String statusCode = 'waiting';
    String statusLabel = 'Menunggu Penanganan';

    if (rawStatus is Map) {
      statusCode = rawStatus['code']?.toString() ?? 'waiting';

      statusLabel = rawStatus['label']?.toString() ?? _statusLabel(statusCode);
    } else if (rawStatus != null) {
      statusCode = rawStatus.toString();
      statusLabel = _statusLabel(statusCode);
    }

    final rawHandledBy = json['handled_by'];

    int? handledById;
    String? handledByName;

    if (rawHandledBy is Map) {
      handledById = _parseNullableInt(rawHandledBy['id']);

      handledByName = rawHandledBy['name']?.toString();
    }

    return LaporanDaruratModel(
      id: _parseInt(json['id']),
      emergencyType: EmergencyType.fromBackendCode(emergencyCode),
      description: json['description']?.toString() ?? '',
      status: statusCode,
      statusLabel: statusLabel,
      feedback: _nullableString(json['feedback']),
      evidencePhotoPath: _nullableString(json['evidence_photo_path']),
      evidencePhotoUrl: _nullableString(json['evidence_photo_url']),
      handledById: handledById,
      handledByName: handledByName,
      handledAt: _parseDateTime(json['handled_at']),
      resolvedAt: _parseDateTime(json['resolved_at']),
      archivedAt: _parseDateTime(json['archived_at']),
      reportedAt: _parseDateTime(json['reported_at']) ?? DateTime.now(),
      createdAt: _parseDateTime(json['created_at']),
      updatedAt: _parseDateTime(json['updated_at']),
    );
  }

  static String _statusLabel(String code) {
    switch (code) {
      case 'in_progress':
        return 'Sedang Ditangani';

      case 'resolved':
        return 'Selesai';

      case 'waiting':
      default:
        return 'Menunggu Penanganan';
    }
  }

  static int _parseInt(dynamic value) {
    if (value is int) {
      return value;
    }

    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  static int? _parseNullableInt(dynamic value) {
    if (value == null) {
      return null;
    }

    if (value is int) {
      return value;
    }

    return int.tryParse(value.toString());
  }

  static DateTime? _parseDateTime(dynamic value) {
    if (value == null) {
      return null;
    }

    final raw = value.toString();

    if (raw.trim().isEmpty) {
      return null;
    }

    return DateTime.tryParse(raw);
  }

  static String? _nullableString(dynamic value) {
    if (value == null) {
      return null;
    }

    final result = value.toString().trim();

    return result.isEmpty ? null : result;
  }
}
