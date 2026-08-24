/// Model nomor penting RT 20
///
/// Field mapping vs ImportantContactResource backend:
///   id          ← id
///   name        ← name
///   category    ← category
///   phoneNumber ← phone_number
///   description ← description  (nullable)
///
/// CATATAN: Backend API tidak mengirim field is_active dalam response.
/// Filter is_active dilakukan di sisi backend (hanya kontak aktif yang
/// dikembalikan oleh endpoint /api/v1/nomor-penting).
/// Field [isActive] dipertahankan dengan default true untuk kompatibilitas
/// MockService dan UI yang sudah ada.
class NomorPentingModel {
  const NomorPentingModel({
    required this.id,
    required this.name,
    required this.category,
    required this.phoneNumber,
    this.description,
    this.isActive = true,
  });

  final int id;
  final String name;
  final String category;
  final String phoneNumber;
  final String? description;

  /// Selalu true untuk data dari API backend karena backend hanya
  /// mengembalikan kontak aktif (scopeActive di ImportantContactController).
  /// Diisi MockService untuk keperluan filtering di development.
  final bool isActive;

  factory NomorPentingModel.fromJson(Map<String, dynamic> json) {
    return NomorPentingModel(
      id: json['id'] as int,
      name: json['name'] as String,
      category: json['category'] as String,
      phoneNumber: json['phone_number'] as String,
      description: json['description'] as String?,
      // is_active tidak dikirim oleh backend API — default true
      // Backend sudah memfilter hanya kontak aktif sebelum dikirim
      isActive: json['is_active'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'phone_number': phoneNumber,
      'description': description,
    };
  }
}
