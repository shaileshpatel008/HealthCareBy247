import 'package:get/get.dart';

import '../../data/models/lookup_models.dart';
import '../../data/repositories/lab_repository.dart';
import '../constants/app_constants.dart';
import 'storage_service.dart';

/// Port of `ConfigContext` + `App.js`'s `sysConfig.php` fetch. Starts from
/// the last saved config (or built-in fallbacks) so Call / WhatsApp / Email
/// work immediately, then refreshes from the server.
class ConfigService extends GetxService {
  final Rx<ConfigModel> config = const ConfigModel(
    callNumbers: AppConstants.fallbackCallNo,
    whatsAppNo: AppConstants.fallbackWhatsAppNo,
    email: AppConstants.fallbackEmail,
    contactPerson: AppConstants.fallbackContactPerson,
    website: AppConstants.fallbackWebsite,
  ).obs;

  ConfigService init() {
    final saved = StorageService.instance.config;
    if (saved != null) config.value = ConfigModel.fromJson(saved);
    refreshConfig();
    return this;
  }

  Future<void> refreshConfig() async {
    try {
      final fresh = await LabRepository.instance.config();
      if (fresh == null) return;
      config.value = fresh;
      StorageService.instance.config = fresh.toJson();
    } catch (_) {
      // Keep the saved/fallback values — contact actions still work.
    }
  }
}
