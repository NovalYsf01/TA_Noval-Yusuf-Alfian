import '../core/utils/html_utils.dart';

/// Model informasi/pengumuman RT 20
///
/// Field mapping vs RtInformationResource backend:
///   id          ← id
///   title       ← title
///   content     ← content
///   imageUrl    ← image_url   (nullable — public URL dari Storage::disk('public'))
///   publishedAt ← published_at
///
/// CATATAN: Backend TIDAK mengirim field 'category'.
/// Field [category] dipertahankan sebagai nullable untuk kompatibilitas
/// MockService yang menggunakannya.
/// Gunakan [categoryDisplay] di UI untuk mendapatkan label yang aman.
class InformasiModel {
  const InformasiModel({
    required this.id,
    required this.title,
    required this.content,
    required this.publishedAt,
    this.category,
    this.imageUrl,
  });

  final int id;
  final String title;
  final String content;

  /// Kategori informasi.
  /// NULLABLE — backend tidak mengirim field ini.
  /// Diisi oleh MockService untuk keperluan development UI.
  /// Jangan menganggap nilai ini berasal dari backend.
  final String? category;

  final DateTime publishedAt;
  final String? imageUrl;

  /// Label kategori yang aman untuk ditampilkan di UI.
  ///
  /// Mengembalikan [category] jika ada (dari MockService atau jika suatu saat
  /// backend menambahkan field ini), atau fallback ke 'Informasi RT' jika null.
  ///
  /// Gunakan getter ini di semua screen, bukan [category] langsung,
  /// agar tidak memerlukan null-check di setiap tempat.
  String get categoryDisplay => category ?? 'Informasi RT';

  /// Mengembalikan konten murni tanpa tag HTML
  String get contentPlainText => HtmlUtils.stripHtml(content);

  /// Preview singkat konten (max 120 karakter) bersih dari tag HTML
  String get contentPreview {
    final plain = contentPlainText;
    if (plain.length <= 120) return plain;
    return '${plain.substring(0, 120)}...';
  }

  factory InformasiModel.fromJson(Map<String, dynamic> json) {
    return InformasiModel(
      id: json['id'] as int,
      title: json['title'] as String,
      content: json['content'] as String,
      // category tidak ada di backend — akan null dari API, fallback tersedia di categoryDisplay
      category: json['category'] as String?,
      publishedAt: DateTime.parse(json['published_at'] as String).toLocal(),
      imageUrl: json['image_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'category': category,
      'published_at': publishedAt.toIso8601String(),
      'image_url': imageUrl,
    };
  }
}
