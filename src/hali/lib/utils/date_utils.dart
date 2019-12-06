import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

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

  static String timeUntil(DateTime date) {
    var locale = 'vn'; // TODO: change local
    return timeago.format(date, locale: locale, allowFromNow: true);
  } 

  static String timeAgo(String target) {
    DateTime dateTime = dateFromString(target);
    return timeUntil(dateTime);
  }
}
