import 'package:intl/intl.dart';

class DateUtils {

  // colors
  static String dateToString(DateTime target) {
    return new DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'").format(target);
  }

}
