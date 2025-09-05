import 'package:intl/intl.dart';

class DateFormatterHelper {
  static String formatDate(String dateStr) {
    if (dateStr.isEmpty) return dateStr;
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('dd MMMM yyyy').format(date);
    } catch (e) {
      return dateStr; // Return original string if parsing fails
    }
  }
}
