import 'package:shared_preferences/shared_preferences.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class CacheHelper {
  final SharedPreferences sharedPreferences;

  CacheHelper({required this.sharedPreferences});

  /// Save data to local storage
  Future<bool> saveData({required String key, required dynamic value}) async {
    if (value is String) return await sharedPreferences.setString(key, value);
    if (value is int) return await sharedPreferences.setInt(key, value);
    if (value is bool) return await sharedPreferences.setBool(key, value);
    if (value is double) return await sharedPreferences.setDouble(key, value);
    return false;
  }

  /// Get data from local storage
  dynamic getData({required String key}) {
    return sharedPreferences.get(key);
  }

  /// Remove data from local storage
  Future<bool> removeData({required String key}) async {
    return await sharedPreferences.remove(key);
  }

  /// Clear all data
  Future<bool> clearData() async {
    return await sharedPreferences.clear();
  }

  /// Check if key exists
  bool containsKey({required String key}) {
    return sharedPreferences.containsKey(key);
  }
}
