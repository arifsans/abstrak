import 'package:intl/intl.dart';

class RupiahFormatter {
  static String rupiahFormatter(
    String? value, {
    bool withSymbol = true,
  }) {
    if (value == null || value == 'null' || value == "") {
      value = "0";
    }

    return NumberFormat.currency(
      locale: 'id',
      symbol: withSymbol ? 'Rp ' : '',
      decimalDigits: 0,
    ).format(double.parse('$value'));
  }
}
