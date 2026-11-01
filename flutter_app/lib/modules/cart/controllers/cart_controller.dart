import 'package:get/get.dart';

import '../../../core/services/cart_service.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/app_dialog.dart';
import '../../../core/widgets/app_toast.dart';
import '../../../data/models/cart_item_model.dart';
import '../../../routes/app_routes.dart';
import '../../booking/controllers/booking_controller.dart';
import '../../home/controllers/home_controller.dart';

/// Port of `MyCartView.js` + `RemoveConfirmPopup`.
class CartController extends GetxController {
  final CartService cart = Get.find<CartService>();

  /// Same "are you sure?" step the RN cart's remove popup asked.
  Future<bool> confirmRemove(CartItemModel item) => AppDialog.confirm(
        type: AppDialogType.warning,
        icon: AppDialogIcon.trash,
        title: 'Remove ${Formatters.titleCase(item.title)}?',
        message: 'This ${item.isPackage ? 'package' : 'test'} will be removed from your cart.',
        confirmText: 'Remove',
        cancelText: 'Keep',
      );

  Future<void> remove(CartItemModel item, {bool confirmed = false}) async {
    if (!confirmed && !await confirmRemove(item)) return;
    cart.remove(item);
    AppToast.info('${Formatters.titleCase(item.title)} removed');
  }

  Future<void> clearAll() async {
    final ok = await AppDialog.confirm(
      type: AppDialogType.warning,
      icon: AppDialogIcon.cart,
      title: 'Empty your cart?',
      message: 'All ${cart.items.length} items will be removed.',
      confirmText: 'Empty cart',
      cancelText: 'Keep',
    );
    if (ok) cart.clear();
  }

  /// RN `placeInqueryFromCart` → "Place Inquiry" screen.
  void proceed() => Get.toNamed(AppRoutes.booking, arguments: BookingMode.cart);

  /// Empty-cart shortcuts back into the catalogue.
  void browse(HomeTab tab) {
    Get.until((route) => route.settings.name == AppRoutes.home);
    if (Get.isRegistered<HomeController>()) Get.find<HomeController>().goTo(tab);
  }
}
