import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/services/cart_service.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/app_toast.dart';
import '../../../core/widgets/cart_bar.dart';
import '../../../core/widgets/fly_to_cart.dart';
import '../../../core/widgets/pressable.dart';
import '../../../core/widgets/screen_header.dart';
import '../../../core/widgets/search_field.dart';
import '../../../core/widgets/stagger.dart';
import '../../../core/widgets/state_views.dart';
import '../../../data/models/lab_test_model.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../../home/controllers/home_controller.dart';
import '../controllers/tests_controller.dart';

/// Board 03 "Book a test".
class TestsView extends GetView<TestsController> {
  const TestsView({super.key});

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
                    title: 'Book a test',
                    subtitle: controller.all.isEmpty ? null : '${controller.all.length} tests available',
                    leading: HeaderLeading.menu,
                    onLeading: Get.find<HomeController>().openMenu,
                    showCart: true,
                  )),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
                child: SearchField(
                  controller: controller.searchController,
                  focusNode: controller.searchFocus,
                  hint: 'Search by test name',
                  onChanged: controller.setQuery,
                  onClear: controller.clearQuery,
                ),
              ),
              SizedBox(
                height: 40,
                child: Obx(() => ListView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      children: [
                        for (final f in SampleFilter.values)
                          Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: _Chip(label: f.label, selected: controller.filter.value == f, onTap: () => controller.filter.value = f),
                          ),
                      ],
                    )),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: Obx(() {
                  if (controller.loading.value) return const SkeletonList();
                  if (controller.error.value != null) {
                    return ErrorState(message: controller.error.value!, onRetry: () => controller.load(refresh: true));
                  }
                  final list = controller.visible;
                  if (list.isEmpty) {
                    return EmptyState(
                      icon: Icons.search_off_rounded,
                      title: 'No test found',
                      message: controller.query.value.isEmpty
                          ? 'No tests match this filter.'
                          : 'Nothing matches “${controller.query.value}”. Try a shorter name.',
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
                      separatorBuilder: (_, _) => const SizedBox(height: 10),
                      itemBuilder: (_, i) => _TestCard(test: list[i], cart: cart).staggerIn(i),
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

class _TestCard extends StatelessWidget {
  const _TestCard({required this.test, required this.cart});
  final LabTestModel test;
  final CartService cart;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final added = cart.hasTest(test);
      final serum = test.sample.toUpperCase().contains('SERUM');
      return AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: added ? AppColors.indigo : Colors.transparent, width: 1.5),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(color: serum ? AppColors.skySoft : AppColors.indigoSoft, borderRadius: BorderRadius.circular(14)),
              child: Icon(serum ? Icons.science_outlined : Icons.water_drop_outlined, color: serum ? AppColors.skyInk : AppColors.indigo, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(test.name, style: AppTextStyles.titleSmall),
                  const SizedBox(height: 2),
                  Text(
                    [if (test.sample.isNotEmpty) Formatters.sample(test.sample), Formatters.rupees(test.rate)].join(' · '),
                    style: AppTextStyles.caption,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Builder(
              builder: (btn) => Pressable(
                semanticLabel: added ? 'Remove ${test.name}' : 'Add ${test.name}',
                onTap: () {
                  if (added) {
                    cart.removeTest(test);
                    AppToast.info('${test.name} removed from cart');
                  } else {
                    FlyToCart.run(btn);
                    cart.addTest(test);
                  }
                },
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 220),
                  transitionBuilder: (c, a) => ScaleTransition(scale: a, child: c),
                  child: added
                      ? _AddButton(key: const ValueKey('added'), label: 'Added', icon: Icons.check_rounded, bg: AppColors.successSoft, fg: AppColors.success)
                      : _AddButton(key: const ValueKey('add'), label: 'Add', icon: Icons.add_rounded, bg: AppColors.indigo, fg: Colors.white),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}

class _AddButton extends StatelessWidget {
  const _AddButton({super.key, required this.label, required this.icon, required this.bg, required this.fg});
  final String label;
  final IconData icon;
  final Color bg;
  final Color fg;

  @override
  Widget build(BuildContext context) => Container(
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(12)),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(icon, size: 16, color: fg),
          const SizedBox(width: 5),
          Text(label, style: TextStyle(color: fg, fontWeight: FontWeight.w800, fontSize: 13)),
        ]),
      );
}

class _Chip extends StatelessWidget {
  const _Chip({required this.label, required this.selected, required this.onTap});
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Pressable(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? AppColors.indigo : Colors.white,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: selected ? AppColors.indigo : AppColors.line),
        ),
        child: Text(
          label,
          style: TextStyle(color: selected ? Colors.white : AppColors.ink, fontWeight: selected ? FontWeight.w700 : FontWeight.w600, fontSize: 13),
        ),
      ),
    );
  }
}
