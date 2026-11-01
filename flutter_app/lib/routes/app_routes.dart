abstract class AppRoutes {
  AppRoutes._();

  static const splash = '/splash';

  /// Bottom-nav shell: Home, Tests, Packages and Contact tabs + side menu.
  static const home = '/home';

  static const packageDetail = '/package-detail';
  static const cart = '/cart';

  /// Booking form. Argument: [BookingMode] — `cart` is the RN
  /// "Place Inquiry" (from the cart), `visit` is "Book Visit" (menu/home).
  static const booking = '/booking';
  static const bookingSuccess = '/booking-success';
  static const uploadPrescription = '/upload-prescription';
  static const facilities = '/facilities';
  static const about = '/about';
}
