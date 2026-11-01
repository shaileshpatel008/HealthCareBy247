import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/services/cart_service.dart';
import '../../../core/widgets/cart_bar.dart';
import '../../../core/widgets/screen_header.dart';
import '../../../core/widgets/search_field.dart';
import '../../../core/widgets/stagger.dart';
import '../../../core/widgets/state_views.dart';
import '../../../theme/app_colors.dart';
import '../../home/controllers/home_controller.dart';
import '../controllers/packages_controller.dart';
import '../widgets/package_card.dart';

/// Health packages tab ("Book Package" in the RN drawer).
class PackagesView extends GetView<PackagesController> {
  const PackagesView({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Get.find<CartService>();
    return SafeArea(
      bottom: false,
      child: Stack(
        children: [
          Column(
            children: [
              Obx(() => ScreenHeader(
                    title: 'Health packages',
                    subtitle: controller.all.isEmpty
                        ? null
                        : '${controller.all.length} packages${controller.maxDiscount > 0 ? ' · save up to ${controller.maxDiscount}%' : ''}',
                    leading: HeaderLeading.menu,
                    onLeading: Get.find<HomeController>().openMenu,
                    showCart: true,
                  )),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
                child: SearchField(
                  controller: controller.searchController,
                  hint: 'Search packages or a test inside',
                  onChanged: (v) => controller.query.value = v,
                  onClear: controller.clearQuery,
                ),
              ),
              Expanded(
                child: Obx(() {
                  if (controller.loading.value) return const SkeletonList();
                  if (controller.error.value != null) {
                    return ErrorState(message: controller.error.value!, onRetry: () => controller.load(refresh: true));
                  }
                  final list = controller.visible;
                  if (list.isEmpty) {
                    return EmptyState(
                      icon: Icons.inventory_2_outlined,
                      title: 'No package found',
                      message: 'Nothing matches “${controller.query.value}”.',
                      actions: [SoftButton(label: 'Clear search', onTap: controller.clearQuery)],
                    );
                  }
                  return RefreshIndicator(
                    color: AppColors.indigo,
                    onRefresh: () => controller.load(refresh: true),
                    child: ListView.separated(
                      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                      padding: EdgeInsets.fromLTRB(20, 4, 20, cart.items.isEmpty ? 120 : 200),
                      itemCount: list.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 12),
                      itemBuilder: (_, i) => PackageCard(package: list[i]).staggerIn(i),
                    ),
                  );
                }),
              ),
            ],
          ),
          const Positioned(left: 16, right: 16, bottom: 0, child: CartBar(aboveNav: true)),
        ],
      ),
    );
  }
}
