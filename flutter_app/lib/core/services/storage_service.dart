import 'package:get_storage/get_storage.dart';

/// GetStorage-backed persistence — port of the RN app's AsyncStorage use
/// (`@cart_items`), plus the last config so contact actions work before the
/// config API answers on a slow connection.
class StorageService {
  StorageService._();
  static final StorageService instance = StorageService._();

  late final GetStorage _box;

  Future<void> init() async {
    await GetStorage.init('healthcare_lab');
    _box = GetStorage('healthcare_lab');
  }

  /// Same key the RN CartContext used.
  List<Map<String, dynamic>> get cartItems =>
      ((_box.read('@cart_items') as List?) ?? const []).whereType<Map>().map((e) => Map<String, dynamic>.from(e)).toList();
  set cartItems(List<Map<String, dynamic>> v) => _box.write('@cart_items', v);

  Map<String, dynamic>? get config {
    final raw = _box.read('sys_config');
    return raw is Map ? Map<String, dynamic>.from(raw) : null;
  }

  set config(Map<String, dynamic>? v) => _box.write('sys_config', v);
}
