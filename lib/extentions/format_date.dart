import 'package:intl/intl.dart';

extension DateFormating on DateTime {
  String formatDate() {
    DateFormat format = DateFormat('dd-MM-yyyy');
    String formatted = format.format(this);
    return formatted;
  }
}
