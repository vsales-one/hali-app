import 'package:date_format/date_format.dart';

class DateUtils {

  // colors
  static String dateToString(DateTime target) {
    return formatDate(target, [HH, ':', nn, ':', ss, ' ', Z]);
  }

}
