import 'package:shared_preferences/shared_preferences.dart';
import 'package:teslo_shop/features/shared/infrastructure/services/storage_service.dart';

class SharedPreferencesStorageServiceImpl implements StorageService {
  Future<SharedPreferences> getSharedPreference() async {
    return await SharedPreferences.getInstance();
  }

  @override
  Future<T?> getValue<T>(String key) async {
    final prefs = await getSharedPreference();

    return switch (T) {
      String => prefs.getString(key) as T?,
      int => prefs.getInt(key) as T?,
      _ => throw Exception('Type not implemented'),
    };
  }

  @override
  Future<bool> removeKey(String key) async {
    final prefs = await getSharedPreference();
    return prefs.remove(key);
  }

  @override
  Future<bool> setKeyValue<T>(String key, T value) async {
    final prefs = await getSharedPreference();

    return switch (T) {
      String => prefs.setString(key, value as String),
      int => prefs.setInt(key, value as int),
      _ => throw Exception('Type not implemented'),
    };
  }
}
