import '../../data/models/lookup_models.dart';

/// What the confirmation screen shows about the booking just placed.
class BookingSuccessArgs {
  const BookingSuccessArgs({
    required this.bookingId,
    required this.name,
    required this.mobile,
    required this.date,
    required this.slot,
    required this.address,
    required this.pincode,
    required this.packageNames,
    required this.testNames,
    required this.prescriptionCount,
    required this.amount,
  });

  final String bookingId;
  final String name;
  final String mobile;
  final DateTime date;
  final TimeSlotModel slot;
  final String address;
  final String pincode;
  final List<String> packageNames;
  final List<String> testNames;
  final int prescriptionCount;
  final num amount;
}
