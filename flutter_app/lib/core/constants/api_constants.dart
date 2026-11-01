/// Production API contract, read directly out of the React Native app
/// (`src/utils/ApiService/api.js` and the screens that call it) so the
/// Flutter client talks to the same backend with no server changes.
///
/// Every GET returns `{"status": "success", "data": [...]}`.
class ApiConstants {
  ApiConstants._();

  static const String baseUrl = 'https://healthcare24x7.com/api/';

  /// GET — call/WhatsApp numbers, email, contact person, website
  /// (`App.js` → ConfigContext; first row of `data` is used).
  static const String sysConfig = 'sysConfig.php';

  /// GET — home carousel banners: `{NewsId, content, preview_url, param}`;
  /// `param == "Y"` makes the banner open the package list (`Home.js`).
  static const String newsletter = 'newsletter.php';

  /// GET — single tests: `{ReportNo, ReportName, ReportRate, Collaction}`.
  static const String reports = 'reportsinfo.php';

  /// GET — packages: `{PackageId, Name, Title, RoutingRate, DiscountRate,
  /// Tests: [{PackageTestId, FullName, Name}]}`. RoutingRate is the MRP,
  /// DiscountRate the price charged.
  static const String packages = 'packageswithTest.php';

  /// GET — collection time slots: `{TimeSlotID, Slot}`, e.g. "07:00 - 07:30".
  static const String timeSlots = 'timeSlot.php';

  /// GET — serviceable pincodes: `{PincodeID, PincodeNumber}`.
  static const String pincodes = 'pincodeinfo.php';

  /// GET — serviceable areas: `{LocationID, LocationName}`.
  static const String areas = 'locationinfo.php';

  /// GET — branches: `{BranchId, Name, Address, ContactNo_1, ContactNo_2,
  /// Pincode, LocationURL, LocationURLIOS}` (`Contactus.js`).
  static const String branches = 'branches.php';

  /// POST multipart — booking / inquiry (`PlaceInquery.js`, `BookAVisit.js`).
  /// Returns `{status: "success", id}` or `{status, message}`.
  static const String registration = 'registration.php';

  /// POST multipart — prescription-only upload from Home
  /// (`SubmitPrescriptions.js`): MobileNo, Name, Prescription[i].
  static const String onlyPrescription = 'onlyPrescription.php';

  // Static pages the RN app shows in a WebView.
  static const String facilitiesPage = 'https://healthcare24x7.com/hcplab-pages/facilities.html';
  static const String instrumentsPage = 'https://healthcare24x7.com/hcplab-pages/Instrument.html';
}
