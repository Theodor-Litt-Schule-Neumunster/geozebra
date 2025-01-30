import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  static Future<T> loadSetting<T>(String key, T defaultValue) async {
    final prefs = await SharedPreferences.getInstance();
    if (defaultValue is bool) {
      return (prefs.getBool(key) ?? defaultValue) as T;
    } else if (defaultValue is int) {
      return (prefs.getInt(key) ?? defaultValue) as T;
    } else if (defaultValue is double) {
      return (prefs.getDouble(key) ?? defaultValue) as T;
    } else if (defaultValue is String) {
      return (prefs.getString(key) ?? defaultValue) as T;
    }
    throw UnsupportedError('loadSetting - Unsupported type');
  }

  static Future<void> saveSetting<T>(String key, T value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value is bool) {
      await prefs.setBool(key, value);
    } else if (value is int) {
      await prefs.setInt(key, value);
    } else if (value is double) {
      await prefs.setDouble(key, value);
    } else if (value is String) {
      await prefs.setString(key, value);
    } else {
      throw UnsupportedError('saveSetting - Unsupported type');
    }
  }
}
