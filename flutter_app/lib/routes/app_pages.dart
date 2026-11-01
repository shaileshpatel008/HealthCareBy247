import 'package:get/get.dart';

import '../modules/about/views/about_view.dart';
import '../modules/booking/bindings/booking_binding.dart';
import '../modules/booking/views/booking_view.dart';
import '../modules/booking_success/views/booking_success_view.dart';
import '../modules/cart/bindings/cart_binding.dart';
import '../modules/cart/views/cart_view.dart';
import '../modules/facilities/bindings/facilities_binding.dart';
import '../modules/facilities/views/facilities_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/package_detail/views/package_detail_view.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';
import '../modules/upload_prescription/bindings/upload_prescription_binding.dart';
import '../modules/upload_prescription/views/upload_prescription_view.dart';
import 'app_routes.dart';

class AppPages {
  AppPages._();

  static final pages = [
    GetPage(name: AppRoutes.splash, page: () => const SplashView(), binding: SplashBinding(), transition: Transition.fadeIn),
    GetPage(name: AppRoutes.home, page: () => const HomeView(), binding: HomeBinding(), transition: Transition.fadeIn),
    GetPage(name: AppRoutes.packageDetail, page: () => const PackageDetailView()),
    GetPage(name: AppRoutes.cart, page: () => const CartView(), binding: CartBinding()),
    GetPage(name: AppRoutes.booking, page: () => const BookingView(), binding: BookingBinding()),
    GetPage(name: AppRoutes.bookingSuccess, page: () => const BookingSuccessView(), transition: Transition.fadeIn),
    GetPage(name: AppRoutes.uploadPrescription, page: () => const UploadPrescriptionView(), binding: UploadPrescriptionBinding()),
    GetPage(name: AppRoutes.facilities, page: () => const FacilitiesView(), binding: FacilitiesBinding()),
    GetPage(name: AppRoutes.about, page: () => const AboutView()),
  ];
}
