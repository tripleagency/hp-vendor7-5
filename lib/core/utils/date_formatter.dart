import 'package:easy_localization/easy_localization.dart';

class DateFormatter {
  DateFormatter._();

  static String formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return '';
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('dd/MM/yyyy').format(date);
    } catch (_) {
      return dateStr;
    }
  }

  static String formatTime(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return '';
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('hh:mm a').format(date);
    } catch (_) {
      return '';
    }
  }

  static String formatDateTime(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return '';
    try {
      final date = DateTime.parse(dateStr);
      return '${DateFormat('dd/MM/yyyy').format(date)} ${DateFormat('hh:mm a').format(date)}';
    } catch (_) {
      return dateStr;
    }
  }
}
