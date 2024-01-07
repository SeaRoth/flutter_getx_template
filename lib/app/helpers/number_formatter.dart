import "package:intl/intl.dart";

class MyNumberFormatter {
  String returnThousandsWithComma(dynamic str) {
    if (str == null) {
      return "0";
    }
    try {
      final nf = NumberFormat("#,##0", "en_US");
      return nf.format(str);
    } catch (e) {
      return "0";
    }
  }

  double calculatePercentage(int numerator, int denominator) {
    try {
      if (denominator == 0) {
        return 0.0;
      }
      return (numerator / denominator * 100).truncateToDouble();
    } catch (e) {
      print('Error occurred: $e');
      return 0;
    }
  }
}
