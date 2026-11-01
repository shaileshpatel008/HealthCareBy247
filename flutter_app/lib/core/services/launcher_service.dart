import 'dart:io';

import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants/app_constants.dart';
import '../widgets/app_dialog.dart';
import 'config_service.dart';

/// Every outbound action the RN app took through `Linking.openURL`, each
/// behind the same confirmation the RN `PromptBox` asked for (call,
/// WhatsApp) and with a friendly error when nothing on the phone can
/// handle the link.
class LauncherService {
  LauncherService._();

  static ConfigService get _config => Get.find<ConfigService>();

  /// Tab bar "Call Us" / branch numbers: `tel:+91<number>`.
  static Future<void> confirmAndCall([String? number]) async {
    final target = _digits(number ?? _config.config.value.primaryCallNo);
    if (target.isEmpty) return;
    final ok = await AppDialog.confirm(
      type: AppDialogType.info,
      icon: AppDialogIcon.phone,
      title: 'Call the lab?',
      message: '+91 $target · We’re open 24×7',
      confirmText: 'Call now',
    );
    if (ok) await _open(Uri.parse('tel:+91$target'), 'We couldn’t open your phone’s dialer.');
  }

  /// Tab bar "WhatsApp": `https://wa.me/+91<WhatsAppNo>?text=Hello`.
  static Future<void> confirmAndWhatsApp() async {
    final target = _digits(_config.config.value.whatsAppNo);
    final ok = await AppDialog.confirm(
      type: AppDialogType.success,
      icon: AppDialogIcon.chat,
      title: 'Chat on WhatsApp?',
      message: 'We’ll open WhatsApp with a ready “Hello” message to the lab.',
      confirmText: 'Open',
      cancelText: 'Not now',
    );
    if (ok) await _open(Uri.parse('https://wa.me/91$target?text=Hello'), 'We couldn’t open WhatsApp.');
  }

  /// Side menu email: `mailto:<Email>`.
  static Future<void> email() =>
      _open(Uri(scheme: 'mailto', path: _config.config.value.email), 'No email app is set up on this phone.');

  /// Side menu lab name: opens `websitename`.
  static Future<void> website() {
    final site = _config.config.value.website;
    return _open(Uri.parse(site.isEmpty ? AppConstants.fallbackWebsite : site), 'We couldn’t open the website.');
  }

  /// Branch map: the branch's own map link when it has one (iOS link on
  /// iOS), else a Google Maps search for the address — `Contactus.openMap`.
  static Future<void> openMap({required String address, String mapUrl = '', String mapUrlIos = ''}) {
    final link = Platform.isIOS && mapUrlIos.isNotEmpty ? mapUrlIos : mapUrl;
    final uri = link.isNotEmpty
        ? Uri.parse(link)
        : Uri.parse('https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(address)}');
    return _open(uri, 'We couldn’t open maps.');
  }

  static Future<void> openStore() =>
      _open(Uri.parse(Platform.isIOS ? AppConstants.appStoreUrl : AppConstants.playStoreUrl), 'We couldn’t open the store.');

  static Future<void> shareApp() => SharePlus.instance.share(
        ShareParams(
          text: 'Book lab tests at home with ${AppConstants.labFullName}.\n'
              'Android: ${AppConstants.playStoreUrl}\niPhone: ${AppConstants.appStoreUrl}',
        ),
      );

  static Future<void> _open(Uri uri, String failMessage) async {
    try {
      final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!opened) throw Exception();
    } catch (_) {
      await AppDialog.show(type: AppDialogType.error, title: 'Couldn’t open link', message: failMessage);
    }
  }

  static String _digits(String s) {
    final d = s.replaceAll(RegExp(r'\D'), '');
    return d.length > 10 ? d.substring(d.length - 10) : d;
  }
}
