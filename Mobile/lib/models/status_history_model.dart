/// Model riwayat perubahan status pengajuan pelayanan
///
/// Sesuai dengan ServiceRequestStatusHistoryResource backend:
///
///   id           ← id
///   oldStatus    ← old_status   (object {code, label} atau null untuk pengajuan baru)
///   newStatus    ← new_status   (object {code, label})
///   note         ← note         (nullable)
///   changedBy    ← changed_by   (object {id, name} atau null)
///   createdAt    ← created_at
///
/// Contoh response backend:
/// {
///   "id": 1,
///   "old_status": null,
///   "new_status": { "code": "pending_verification", "label": "Menunggu Verifikasi" },
///   "note": "Pengajuan pelayanan dibuat oleh warga.",
///   "changed_by": { "id": 2, "name": "Ahmad Subagyo" },
///   "created_at": "2026-08-18T21:00:01.000000Z"
/// }
class StatusHistoryModel {
  const StatusHistoryModel({
    required this.id,
    required this.newStatusCode,
    required this.newStatusLabel,
    required this.createdAt,
    this.oldStatusCode,
    this.oldStatusLabel,
    this.note,
    this.changedById,
    this.changedByName,
  });

  final int id;

  /// Kode status lama (English, sesuai ServiceRequestStatus enum backend).
  /// Null untuk entry pertama (saat pengajuan dibuat).
  final String? oldStatusCode;

  /// Label status lama dalam Bahasa Indonesia.
  /// Null untuk entry pertama.
  final String? oldStatusLabel;

  /// Kode status baru (English, sesuai ServiceRequestStatus enum backend).
  final String newStatusCode;

  /// Label status baru dalam Bahasa Indonesia.
  final String newStatusLabel;

  /// Catatan perubahan status (alasan tolak, dll).
  final String? note;

  /// ID user yang melakukan perubahan (warga atau ketua RT).
  final int? changedById;

  /// Nama user yang melakukan perubahan.
  final String? changedByName;

  final DateTime createdAt;

  /// Parse dari JSON response API (ServiceRequestStatusHistoryResource)
  factory StatusHistoryModel.fromJson(Map<String, dynamic> json) {
    // old_status bisa null (entry pertama) atau object {code, label}
    final oldStatusRaw = json['old_status'];
    String? oldCode;
    String? oldLabel;
    if (oldStatusRaw is Map<String, dynamic>) {
      oldCode = oldStatusRaw['code'] as String?;
      oldLabel = oldStatusRaw['label'] as String?;
    }

    // new_status selalu object {code, label}
    final newStatusRaw = json['new_status'] as Map<String, dynamic>?;
    final newCode = newStatusRaw?['code'] as String? ?? '';
    final newLabel = newStatusRaw?['label'] as String? ?? '';

    // changed_by bisa null atau object {id, name}
    final changedByRaw = json['changed_by'];
    int? changedById;
    String? changedByName;
    if (changedByRaw is Map<String, dynamic>) {
      changedById = changedByRaw['id'] as int?;
      changedByName = changedByRaw['name'] as String?;
    }

    return StatusHistoryModel(
      id: json['id'] as int,
      oldStatusCode: oldCode,
      oldStatusLabel: oldLabel,
      newStatusCode: newCode,
      newStatusLabel: newLabel,
      note: json['note'] as String?,
      changedById: changedById,
      changedByName: changedByName,
      createdAt: DateTime.parse(json['created_at'] as String).toLocal(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'old_status': oldStatusCode != null
          ? {'code': oldStatusCode, 'label': oldStatusLabel}
          : null,
      'new_status': {'code': newStatusCode, 'label': newStatusLabel},
      'note': note,
      'changed_by': changedById != null
          ? {'id': changedById, 'name': changedByName}
          : null,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
