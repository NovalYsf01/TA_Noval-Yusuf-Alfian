/// Model data warga untuk aplikasi WARGA 20
///
/// Siap untuk integrasi API Laravel.
/// Gunakan [UserModel.fromJson] untuk parsing response API.
///
/// Field mapping vs UserResource backend:
///   id            ← id
///   name          ← name
///   username      ← username
///   houseCode     ← house_code  (nullable)
///   address       ← address
///   phone         ← phone       (nullable)
///   email         ← email       (nullable)
///   avatarUrl     ← avatar_url  (nullable — public URL dari Storage::disk('public'))
///   isActive      ← is_active
///   role          ← role        (backend selalu mengirim 'warga' untuk API mobile)
class UserModel {
  const UserModel({
    required this.id,
    required this.username,
    required this.name,
    required this.address,
    this.houseCode,
    this.phone,
    this.email,
    this.avatarUrl,
    this.role = 'warga',
    this.isActive = true,
  });

  final int id;
  final String username;
  final String name;
  final String address;

  /// Kode rumah unik warga (dari kolom house_code di backend).
  /// Nullable karena akun admin/ketua RT tidak memiliki house_code.
  final String? houseCode;

  final String? phone;
  final String? email;

  /// URL avatar publik dari Laravel Storage::disk('public').
  /// Nullable — backend mengirim null jika belum ada avatar,
  /// atau URL Gravatar sebagai fallback (hanya di Filament, bukan di API mobile).
  final String? avatarUrl;

  final String role;
  final bool isActive;

  /// Parse dari JSON response API Laravel (UserResource)
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int,
      username: json['username'] as String,
      name: json['name'] as String,
      address: json['address'] as String? ?? '',
      houseCode: json['house_code'] as String?,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      role: json['role'] as String? ?? 'warga',
      isActive: json['is_active'] as bool? ?? true,
    );
  }

  /// Konversi ke JSON (untuk update profile)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'name': name,
      'address': address,
      'house_code': houseCode,
      'phone': phone,
      'email': email,
      'avatar_url': avatarUrl,
      'role': role,
      'is_active': isActive,
    };
  }

  /// Copy with untuk update field tertentu
  UserModel copyWith({
    int? id,
    String? username,
    String? name,
    String? address,
    String? houseCode,
    String? phone,
    String? email,
    String? avatarUrl,
    String? role,
    bool? isActive,
  }) {
    return UserModel(
      id: id ?? this.id,
      username: username ?? this.username,
      name: name ?? this.name,
      address: address ?? this.address,
      houseCode: houseCode ?? this.houseCode,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      role: role ?? this.role,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  String toString() {
    return 'UserModel(id: $id, username: $username, name: $name)';
  }
}
