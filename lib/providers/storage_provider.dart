import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  Future<void> saveData(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  Future<String?> getData(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  Future<void> removeData(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }
}

final localStorageServiceProvider = Provider<LocalStorageService>((ref) {
  return LocalStorageService();
});

final localStorageDataProvider =
    FutureProvider.family<String?, String>((ref, key) async {
  final localStorageService = ref.read(localStorageServiceProvider);
  return await localStorageService.getData(key);
});

class Test extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final name = ref.watch(localStorageDataProvider('user'));
    return name.when(
        data: (text) => Text(text ?? ""),
        error: (error, stack) => Text('Error'),
        loading: () => Text('Loading'),
        );
  }
}
