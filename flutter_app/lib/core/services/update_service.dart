import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../constants/app_constants.dart';
import '../widgets/update_sheet.dart';

/// Port of `App.js`'s `VersionCheck.needUpdate()` → `UpdateModal`: when the
/// store has a newer version, show a sheet the patient can't dismiss until
/// they update (the RN modal had no close button either).
///
/// Android asks Google Play directly (works only for installs that came
/// from Play — a sideloaded test build simply sees "no update"). iOS
/// compares this build's version with the App Store listing.
class UpdateService {
  UpdateService._();

  static bool _checked = false;

  static Future<void> checkOnce() async {
    if (_checked) return;
    _checked = true;
    try {
      if (Platform.isAndroid) {
        final info = await InAppUpdate.checkForUpdate();
        if (info.updateAvailability == UpdateAvailability.updateAvailable) {
          await UpdateSheet.show(onUpdate: _updateAndroid);
        }
      } else if (Platform.isIOS) {
        final storeVersion = await _appStoreVersion();
        final current = (await PackageInfo.fromPlatform()).version;
        if (storeVersion != null && _isNewer(storeVersion, current)) {
          await UpdateSheet.show();
        }
      }
    } catch (_) {
      // No store, no network, or not installed from a store — never block
      // the app over a failed check.
    }
  }

  /// Play's own full-screen update flow; if it fails or is cancelled the
  /// sheet falls back to opening the Play listing.
  static Future<void> _updateAndroid() => InAppUpdate.performImmediateUpdate();

  static Future<String?> _appStoreVersion() async {
    // Apple serves this as text/javascript, so Dio hands back a String.
    final response = await Dio().get<String>(AppConstants.appStoreLookupUrl, options: Options(responseType: ResponseType.plain));
    final data = jsonDecode(response.data ?? '{}');
    final results = (data is Map ? data['results'] : null) as List?;
    if (results == null || results.isEmpty) return null;
    return (results.first as Map)['version']?.toString();
  }

  /// Numeric dotted-version compare ("1.10.0" > "1.9.3").
  static bool _isNewer(String store, String current) {
    List<int> parts(String v) => v.split('.').map((p) => int.tryParse(p.replaceAll(RegExp(r'\D'), '')) ?? 0).toList();
    final a = parts(store), b = parts(current);
    for (var i = 0; i < 3; i++) {
      final x = i < a.length ? a[i] : 0, y = i < b.length ? b[i] : 0;
      if (x != y) return x > y;
    }
    return false;
  }
}
