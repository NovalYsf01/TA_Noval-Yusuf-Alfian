/// Utilitas untuk memanipulasi string HTML
class HtmlUtils {
  HtmlUtils._();

  /// Menghapus semua tag HTML dari string dan mengembalikan plain text.
  /// Sangat sederhana: menghapus apapun di antara < dan >.
  static String stripHtml(String htmlString) {
    RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);
    // Ganti tag HTML dengan string kosong, lalu trim spasi berlebih
    return htmlString.replaceAll(exp, '').trim();
  }
}
