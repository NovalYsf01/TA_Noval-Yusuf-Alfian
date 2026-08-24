import 'package:intl/intl.dart';

/// Utility class untuk formatting tanggal
class DateFormatUtils {
  DateFormatUtils._();

  /// Format: 18 Agu 2026
  static String formatDate(DateTime date) {
    return DateFormat('dd MMM yyyy', 'id').format(date);
  }

  /// Format: 18 Agustus 2026
  static String formatDateLong(DateTime date) {
    return DateFormat('dd MMMM yyyy', 'id').format(date);
  }

  /// Format: 18 Agu 2026, 14:30
  static String formatDateTime(DateTime date) {
    return DateFormat('dd MMM yyyy, HH:mm', 'id').format(date);
  }

  /// Format: 14:30
  static String formatTime(DateTime date) {
    return DateFormat('HH:mm').format(date);
  }

  /// Hitung berapa lama dari sekarang (misal: 2 hari lalu)
  static String timeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inDays > 30) return formatDate(date);
    if (diff.inDays > 0) return '${diff.inDays} hari lalu';
    if (diff.inHours > 0) return '${diff.inHours} jam lalu';
    if (diff.inMinutes > 0) return '${diff.inMinutes} menit lalu';
    return 'Baru saja';
  }
}
