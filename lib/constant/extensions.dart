
import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  String formatDate() {
    return this.day.toString().padLeft(2, '0');
  }
}
extension DoubleExtensions on double {
  String roundOffStrict({int decimals = 2}) {
    String pattern = "0.00";
    switch (decimals) {
      case 1:
        pattern = "0.0";
        break;
      case 2:
        pattern = "0.00";
        break;
      case 3:
        pattern = "0.000";
        break;
    }

    if (this.toString().isEmpty || this == 0.0) {
      return pattern;
    } else {
      final df = NumberFormat(pattern);
      return df.format(this);
    }
  }
}


