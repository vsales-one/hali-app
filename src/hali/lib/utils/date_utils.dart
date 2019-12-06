import 'package:intl/intl.dart';

class DateUtils {

  // colors
  static String dateToString(DateTime target) {
    return new DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'").format(target);
  }

  static DateTime dateFromString(String target) {
    return DateTime.parse(target);
  }

  static String formatDateAsString(DateTime value) {
    if (value == null) {
      return '';
    }
    final formatter = DateFormat.yMMMd().add_Hm();
      return formatter.format(value);
  }

}
