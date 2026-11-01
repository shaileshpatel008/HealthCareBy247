import 'package:geolocator/geolocator.dart';

import '../widgets/app_dialog.dart';

/// "Visit location" on the booking form — port of `startWatchingLocation`
/// (`Geolocation.getCurrentPosition`), with each failure explained and a
/// direct route to the setting that fixes it instead of the RN app's single
/// "Location is off" alert.
class LocationService {
  LocationService._();

  static Future<Position?> currentPosition() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      final open = await AppDialog.confirm(
        type: AppDialogType.warning,
        icon: AppDialogIcon.location,
        title: 'Location is off',
        message: 'Turn on location so our team can find your address for sample collection.',
        confirmText: 'Turn on',
      );
      if (open) await Geolocator.openLocationSettings();
      return null;
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.deniedForever) {
      final open = await AppDialog.confirm(
        type: AppDialogType.warning,
        icon: AppDialogIcon.location,
        title: 'Location permission needed',
        message: 'Location access was turned off for this app. Allow it in Settings to share your visit location.',
        confirmText: 'Open settings',
      );
      if (open) await Geolocator.openAppSettings();
      return null;
    }
    if (permission == LocationPermission.denied) return null;

    try {
      return await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.high, timeLimit: Duration(seconds: 30)),
      );
    } catch (_) {
      final last = await Geolocator.getLastKnownPosition();
      if (last != null) return last;
      await AppDialog.show(
        type: AppDialogType.error,
        title: 'Couldn’t get your location',
        message: 'Move near a window or step outside, then tap “Use my current location” again.',
      );
      return null;
    }
  }
}
