import 'package:intl/intl.dart';

class Formatters {
  Formatters._();

  static final NumberFormat _inr = NumberFormat.decimalPattern('en_IN');

  /// ₹1,800 — Indian grouping, no decimals for whole amounts.
  static String rupees(num v) => '₹${_inr.format(v % 1 == 0 ? v.toInt() : v)}';

  /// "618" → "600" for "600+ tests".
  static int roundDown(int n) => n >= 100 ? (n ~/ 100) * 100 : n;

  static String greeting([DateTime? now]) {
    final h = (now ?? DateTime.now()).hour;
    if (h < 12) return 'Good morning';
    if (h < 17) return 'Good afternoon';
    return 'Good evening';
  }

  /// The API sends names in capitals ("TOTAL BODY CHECK UP"). Title-case
  /// them for display, keeping short codes (CBC, TSH, HIV, HbA1c-style
  /// tokens with digits) as they are.
  static String titleCase(String s) {
    final words = s.trim().split(RegExp(r'\s+'));
    return words.map((w) {
      if (w.isEmpty) return w;
      final letters = w.replaceAll(RegExp(r'[^A-Za-z]'), '');
      if (letters.length <= 4 || RegExp(r'\d').hasMatch(w)) return w;
      return w[0].toUpperCase() + w.substring(1).toLowerCase();
    }).join(' ');
  }

  /// "1 CC SERUM" → "1 cc serum".
  static String sample(String s) => s.toLowerCase().replaceAll(RegExp(r'\s*;\s*'), ', ');
}
