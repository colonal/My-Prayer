import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper {
  static SharedPreferences? sharedPreferences;
  static Future<bool> init() async {
    // ignore: invalid_use_of_visible_for_testing_member
    // SharedPreferences.setMockInitialValues({});
    sharedPreferences = await SharedPreferences.getInstance();
    return true;
  }

  static Future<bool> putBoolean(
      {required String key, required bool value}) async {
    return await sharedPreferences!.setBool(key, value);
  }

  static Future<bool> saveData(
      {required String key, required dynamic value}) async {
    if (value is String) return await sharedPreferences!.setString(key, value);
    if (value is int) return await sharedPreferences!.setInt(key, value);
    if (value is bool) return await sharedPreferences!.setBool(key, value);
    if (value is List<String>) {
      return await sharedPreferences!.setStringList(key, value);
    }

    return await sharedPreferences!.setDouble(key, value);
  }

  static dynamic getData({required String key}) {
    return sharedPreferences!.get(key);
  }

  static List<String> getDataList({required String key}) {
    return sharedPreferences!.getStringList(key) ?? [];
  }

  static Future clearData({required key}) async {
    return await sharedPreferences!.remove(key);
  }
}
