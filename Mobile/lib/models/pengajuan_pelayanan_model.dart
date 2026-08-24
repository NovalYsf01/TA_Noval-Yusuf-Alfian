import 'status_history_model.dart';

/// Status pengajuan pelayanan administrasi
///
/// Nilai enum Dart menggunakan Bahasa Indonesia untuk keterbacaan kode.
/// Label UI tetap Bahasa Indonesia.
/// apiValue disesuaikan dengan ServiceRequestStatus backend (English):
///
///   Backend value          Flutter enum
///   ─────────────────────────────────────
///   pending_verification → menungguVerifikasi
///   processing           → diproses
///   rejected             → ditolak
///   completed            → selesai
///
/// Backend mengirim status sebagai object:
///   { "code": "pending_verification", "label": "Menunggu Verifikasi" }
/// Parsing menggunakan [fromBackendCode] dari field "code".
enum PengajuanStatus {
  menungguVerifikasi,
  diproses,
  ditolak,
  selesai;

  /// Label Bahasa Indonesia untuk ditampilkan di UI
  String get label {
    switch (this) {
      case PengajuanStatus.menungguVerifikasi:
        return 'Menunggu Verifikasi';
      case PengajuanStatus.diproses:
        return 'Diproses';
      case PengajuanStatus.ditolak:
        return 'Ditolak';
      case PengajuanStatus.selesai:
        return 'Selesai';
    }
  }

  /// Nilai yang dikirim ke API backend (English, sesuai ServiceRequestStatus enum)
  String get apiValue {
    switch (this) {
      case PengajuanStatus.menungguVerifikasi:
        return 'pending_verification';
      case PengajuanStatus.diproses:
        return 'processing';
      case PengajuanStatus.ditolak:
        return 'rejected';
      case PengajuanStatus.selesai:
        return 'completed';
    }
  }

  /// Parse dari code backend (English).
  /// Backend mengirim status sebagai object { "code": "...", "label": "..." }.
  /// Gunakan metode ini dengan nilai dari status["code"].
  static PengajuanStatus fromBackendCode(String code) {
    switch (code.toLowerCase()) {
      case 'pending_verification':
        return PengajuanStatus.menungguVerifikasi;
      case 'processing':
        return PengajuanStatus.diproses;
      case 'rejected':
        return PengajuanStatus.ditolak;
      case 'completed':
        return PengajuanStatus.selesai;
      default:
        return PengajuanStatus.menungguVerifikasi;
    }
  }

  /// Parse dari string (untuk kompatibilitas MockService yang menggunakan
  /// nilai Bahasa Indonesia secara internal).
  /// Mendukung nilai English maupun Bahasa Indonesia.
  static PengajuanStatus fromString(String value) {
    switch (value.toLowerCase()) {
      // English (backend canonical values)
      case 'pending_verification':
        return PengajuanStatus.menungguVerifikasi;
      case 'processing':
        return PengajuanStatus.diproses;
      case 'rejected':
        return PengajuanStatus.ditolak;
      case 'completed':
        return PengajuanStatus.selesai;
      // Bahasa Indonesia (nilai internal mock lama — backward compat)
      case 'menunggu_verifikasi':
      case 'menunggu':
      case 'verifikasi':
        return PengajuanStatus.menungguVerifikasi;
      case 'diproses':
        return PengajuanStatus.diproses;
      case 'ditolak':
        return PengajuanStatus.ditolak;
      case 'selesai':
        return PengajuanStatus.selesai;
      default:
        return PengajuanStatus.menungguVerifikasi;
    }
  }
}

/// Model pengajuan pelayanan administrasi RT 20
///
/// Field mapping vs ServiceRequestResource backend:
///   id                       ← id
///   requestNumber            ← request_number   (format: PEL-XXXX dari backend)
///   purpose                  ← purpose
///   description              ← description
///   status                   ← status.code      (backend kirim object {code, label})
///   adminNote                ← admin_note
///   hasAttachment            ← has_attachment
///   attachmentDownloadUrl    ← attachment_download_url (URL endpoint download privat)
///   hasResultDocument        ← has_result_document
///   resultDocumentDownloadUrl← result_document_download_url
///   submittedAt              ← submitted_at
///   processedAt              ← processed_at
///   rejectedAt               ← rejected_at
///   completedAt              ← completed_at
///   statusHistory            ← status_history   (whenLoaded di resource)
///
/// Field hanya untuk MockService (tidak dari backend):
///   attachment               ← path file lokal saat pick file (sebelum upload)
class PengajuanPelayananModel {
  const PengajuanPelayananModel({
    required this.id,
    required this.userId,
    required this.purpose,
    required this.status,
    required this.submittedAt,
    this.requestNumber,
    this.description,
    this.attachment,
    this.adminNote,
    this.hasAttachment = false,
    this.attachmentDownloadUrl,
    this.hasResultDocument = false,
    this.resultDocumentDownloadUrl,
    this.processedAt,
    this.rejectedAt,
    this.completedAt,
    this.statusHistory,
  });

  final int id;
  final int userId;

  /// Nomor pengajuan dari backend (format: PEL-XXXXXXXXXXXXXXXX).
  /// Nullable untuk kompatibilitas MockService yang tidak menghasilkan nomor ini.
  final String? requestNumber;

  final String purpose;
  final String? description;

  /// Path file lokal (diisi saat user memilih file sebelum upload).
  /// Hanya digunakan oleh MockService dan UI form.
  /// Setelah integrasi API, field ini tidak lagi diisi dari backend.
  final String? attachment;

  final PengajuanStatus status;
  final String? adminNote;

  /// Apakah pengajuan memiliki lampiran yang tersimpan di backend.
  final bool hasAttachment;

  /// URL endpoint download lampiran (privat, memerlukan Bearer token).
  /// Format: /api/v1/pelayanan/{id}/lampiran
  final String? attachmentDownloadUrl;

  /// Apakah dokumen hasil (PDF) sudah tersedia di backend.
  final bool hasResultDocument;

  /// URL endpoint download dokumen hasil PDF (privat, memerlukan Bearer token).
  /// Format: /api/v1/pelayanan/{id}/dokumen-hasil
  /// TODO: Fase 3 – download dengan HTTP client + Bearer token, bukan url_launcher.
  final String? resultDocumentDownloadUrl;

  final DateTime submittedAt;
  final DateTime? processedAt;
  final DateTime? rejectedAt;
  final DateTime? completedAt;

  /// Riwayat perubahan status pengajuan.
  /// Diisi saat backend mengirim relasi statusHistories (whenLoaded).
  final List<StatusHistoryModel>? statusHistory;

  // ─── Compatibility getter untuk UI existing ───────────────────────────────

  /// Nomor pengajuan untuk ditampilkan di UI.
  ///
  /// Mengembalikan [requestNumber] dari backend jika tersedia.
  /// Jika tidak (MockService / offline), fallback ke format WRG-XXXXX.
  /// Screen menggunakan getter ini sehingga tidak perlu diubah.
  String get nomorPengajuan =>
      requestNumber ?? 'WRG-${id.toString().padLeft(5, '0')}';

  /// Compatibility getter — mengembalikan URL download dokumen hasil.
  /// Screen lama menggunakan [resultDocument]; arahkan ke field baru.
  String? get resultDocument => resultDocumentDownloadUrl;

  // ─── JSON ─────────────────────────────────────────────────────────────────

  factory PengajuanPelayananModel.fromJson(Map<String, dynamic> json) {
    // Backend mengirim status sebagai object: { "code": "...", "label": "..." }
    final statusRaw = json['status'];
    final PengajuanStatus status;
    if (statusRaw is Map<String, dynamic>) {
      status = PengajuanStatus.fromBackendCode(
          statusRaw['code'] as String? ?? 'pending_verification');
    } else if (statusRaw is String) {
      // Fallback jika suatu saat backend mengirim string langsung
      status = PengajuanStatus.fromString(statusRaw);
    } else {
      status = PengajuanStatus.menungguVerifikasi;
    }

    // status_history (optional, dikirim hanya saat relasi dimuat)
    List<StatusHistoryModel>? statusHistory;
    final historyRaw = json['status_history'];
    if (historyRaw is List) {
      statusHistory = historyRaw
          .whereType<Map<String, dynamic>>()
          .map(StatusHistoryModel.fromJson)
          .toList();
    }

    return PengajuanPelayananModel(
      id: json['id'] as int,
      userId: json['user_id'] as int? ?? 0,
      requestNumber: json['request_number'] as String?,
      purpose: json['purpose'] as String,
      description: json['description'] as String?,
      status: status,
      adminNote: json['admin_note'] as String?,
      hasAttachment: json['has_attachment'] as bool? ?? false,
      attachmentDownloadUrl: json['attachment_download_url'] as String?,
      hasResultDocument: json['has_result_document'] as bool? ?? false,
      resultDocumentDownloadUrl:
          json['result_document_download_url'] as String?,
      submittedAt: DateTime.parse(json['submitted_at'] as String).toLocal(),
      processedAt: json['processed_at'] != null
          ? DateTime.parse(json['processed_at'] as String).toLocal()
          : null,
      rejectedAt: json['rejected_at'] != null
          ? DateTime.parse(json['rejected_at'] as String).toLocal()
          : null,
      completedAt: json['completed_at'] != null
          ? DateTime.parse(json['completed_at'] as String).toLocal()
          : null,
      statusHistory: statusHistory,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'request_number': requestNumber,
      'purpose': purpose,
      'description': description,
      'status': status.apiValue,
      'admin_note': adminNote,
      'has_attachment': hasAttachment,
      'attachment_download_url': attachmentDownloadUrl,
      'has_result_document': hasResultDocument,
      'result_document_download_url': resultDocumentDownloadUrl,
      'submitted_at': submittedAt.toIso8601String(),
      'processed_at': processedAt?.toIso8601String(),
      'rejected_at': rejectedAt?.toIso8601String(),
      'completed_at': completedAt?.toIso8601String(),
    };
  }
}
