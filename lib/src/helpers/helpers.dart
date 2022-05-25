import 'package:intl/intl.dart';

String convertDate(date) {
    var dateValue = DateFormat("yyyy-MM-ddTHH:mm:ssZ").parseUTC(date).toLocal();
    String formattedDate = DateFormat("yy-MM-dd HH:mm").format(dateValue);
    return formattedDate;
  }