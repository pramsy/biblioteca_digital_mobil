import 'package:intl/intl.dart';

class DateHelper {
  static String formatDateTime(DateTime date) {
    return DateFormat('dd/MM/yyyy HH:mm').format(date);
  }

  static DateTime parseDateTime(String dateStr) {
    return DateTime.parse(dateStr);
  }
}
