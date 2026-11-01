import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../core/constants/api_constants.dart';

/// Port of the RN Facilities + Instrument drawer screens. Both were
/// WebViews of pages on healthcare24x7.com; here both tabs still show
/// those live pages (so any edit the lab makes on its website shows up
/// without an app release), inside the redesigned screen.
class FacilitiesController extends GetxController with GetSingleTickerProviderStateMixin {
  late final TabController tabs = TabController(length: 2, vsync: this, initialIndex: _initialTab);

  /// `Get.arguments == 1` opens straight on Instruments.
  int get _initialTab => Get.arguments == 1 ? 1 : 0;

  final RxList<int> progress = <int>[0, 0].obs;
  final RxList<bool> failed = <bool>[false, false].obs;

  late final List<WebViewController> pages = [
    _page(0, ApiConstants.facilitiesPage, interactive: false),
    _page(1, ApiConstants.instrumentsPage, interactive: true),
  ];

  /// Facilities had touches disabled in RN (a read-only page); Instruments
  /// allowed pinch-zoom. Same here.
  WebViewController _page(int i, String url, {required bool interactive}) {
    final c = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..setNavigationDelegate(NavigationDelegate(
        onProgress: (p) => progress[i] = p,
        onPageFinished: (_) {
          progress[i] = 100;
          pages[i].runJavaScript(_viewportJs(interactive));
        },
        onWebResourceError: (e) {
          if (e.isForMainFrame ?? true) failed[i] = true;
        },
        // Keep the patient on the lab's own pages, as the RN WebViews did
        // (links out were not followable there either).
        onNavigationRequest: (r) =>
            Uri.tryParse(r.url)?.host.endsWith('healthcare24x7.com') ?? false ? NavigationDecision.navigate : NavigationDecision.prevent,
      ))
      ..loadRequest(Uri.parse(url));
    return c;
  }

  String _viewportJs(bool zoomable) => '''
    var m = document.createElement('meta');
    m.setAttribute('name', 'viewport');
    m.setAttribute('content', 'width=device-width, initial-scale=1${zoomable ? ', maximum-scale=3, user-scalable=yes' : ', maximum-scale=1, user-scalable=no'}');
    document.head.appendChild(m);
    ${zoomable ? '' : "document.body.style.pointerEvents = 'none';"}
    true;
  ''';

  void reload(int i) {
    failed[i] = false;
    progress[i] = 0;
    pages[i].reload();
  }

  @override
  void onClose() {
    tabs.dispose();
    super.onClose();
  }
}
