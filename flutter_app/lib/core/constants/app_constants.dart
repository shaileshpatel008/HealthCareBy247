/// App-wide constants that aren't API endpoints.
class AppConstants {
  AppConstants._();

  static const String appName = 'Health Care Lab';
  static const String labFullName = 'Health Care 24×7 Pathology & Endocrine Laboratory';

  /// Store links used by the update prompt and "Share the app". These point
  /// at the live listing (`com.healthcarelab` / App Store id1344409972),
  /// the same URLs the RN app's `UpdateModal` opens.
  static const String playStoreUrl = 'https://play.google.com/store/apps/details?id=com.healthcarelab';
  static const String appStoreUrl = 'https://apps.apple.com/us/app/healthcare-24x7-pathology-lab/id1344409972';
  static const String appStoreId = '1344409972';

  /// iOS update check: the live listing is only on the India storefront,
  /// so the lookup must name it (a plain lookup returns no results).
  static const String appStoreLookupUrl = 'https://itunes.apple.com/in/lookup?id=$appStoreId';

  /// Fallbacks used only until `sysConfig.php` answers (or if it fails), so
  /// Call / WhatsApp / Email never act on an empty number. Values are the
  /// ones the config API returns today.
  static const String fallbackCallNo = '9537299801';
  static const String fallbackWhatsAppNo = '9537299801';
  static const String fallbackEmail = 'healthcare24x7@gmail.com';
  static const String fallbackContactPerson = 'Dr. Hiral Faldu';
  static const String fallbackWebsite = 'https://healthcare24x7.com/';

  /// Prescription photos: same limits the RN gallery picker used
  /// (`selectionLimit: 5`, `quality: 0.5`).
  static const int maxPrescriptionImages = 5;
  static const int imageQuality = 50;
  static const int maxImageBytes = 5 * 1024 * 1024;
}
