import 'package:intl/intl.dart';

int weekdayInt() {
  List<String> weekdays = [
    "Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, Sunday"
  ];
  String today = DateFormat.EEEE().format(DateTime.now());
  int dayNum = weekdays.indexOf(today);
  return dayNum;
}

String numFix(int num) {
  if (num < 10) {
    return "0$num";
  } else {
    return num.toString();
  }
}

void monthDayPass() {}
