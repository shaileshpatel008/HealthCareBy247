import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

/// Port of `useNetworkStatus` (NetInfo): one observable online flag. The
/// app shell shows the full-screen "You're offline" state while it's false,
/// exactly where the RN app swapped in `NoInternetScreen`.
class ConnectivityService extends GetxService {
  final RxBool isOnline = true.obs;
  StreamSubscription<List<ConnectivityResult>>? _sub;

  Future<ConnectivityService> init() async {
    isOnline.value = _online(await Connectivity().checkConnectivity());
    _sub = Connectivity().onConnectivityChanged.listen((results) => isOnline.value = _online(results));
    return this;
  }

  /// "Try again" on the offline screen.
  Future<void> recheck() async => isOnline.value = _online(await Connectivity().checkConnectivity());

  bool _online(List<ConnectivityResult> results) => results.isNotEmpty && !results.contains(ConnectivityResult.none);

  @override
  void onClose() {
    _sub?.cancel();
    super.onClose();
  }
}
