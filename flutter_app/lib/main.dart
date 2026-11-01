import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'core/constants/app_constants.dart';
import 'core/services/cart_service.dart';
import 'core/services/config_service.dart';
import 'core/services/connectivity_service.dart';
import 'core/services/storage_service.dart';
import 'core/widgets/offline_view.dart';
import 'routes/app_pages.dart';
import 'routes/app_routes.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Transparent status bar with dark icons over the light background every
  // screen has; screens with an indigo top (splash, package detail) set
  // their own light style.
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.light,
    systemNavigationBarColor: Colors.white,
    systemNavigationBarIconBrightness: Brightness.dark,
  ));
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await initializeDateFormatting('en_IN');

  await StorageService.instance.init();
  await Get.putAsync(() => ConnectivityService().init(), permanent: true);
  Get.put(CartService().init(), permanent: true);
  Get.put(ConfigService().init(), permanent: true);

  runApp(const HealthCareApp());
}

class HealthCareApp extends StatelessWidget {
  const HealthCareApp({super.key});

  @override
  Widget build(BuildContext context) {
    final connectivity = Get.find<ConnectivityService>();
    return GetMaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      initialRoute: AppRoutes.splash,
      getPages: AppPages.pages,
      // Motion board "Page transition": new screens slide in from the right
      // with a fade, 300 ms.
      defaultTransition: Transition.rightToLeftWithFade,
      transitionDuration: const Duration(milliseconds: 300),
      // Port of App.js's AppContentWithOffline: while offline the whole app
      // is covered by the offline screen, and uncovered when it reconnects.
      builder: (context, child) => Obx(
        () => Stack(
          children: [
            ?child,
            if (!connectivity.isOnline.value) const Positioned.fill(child: OfflineView()),
          ],
        ),
      ),
    );
  }
}
