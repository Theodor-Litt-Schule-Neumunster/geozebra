import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  /// Load a specific setting by key, with a default value if the key doesn't exist.
  static Future<T> loadSetting<T>(String key, T defaultValue) async {
    final prefs = await SharedPreferences.getInstance();
    if (T == bool) return (prefs.getBool(key) ?? defaultValue) as T;
    if (T == int) return (prefs.getInt(key) ?? defaultValue) as T;
    if (T == double) return (prefs.getDouble(key) ?? defaultValue) as T;
    if (T == String) return (prefs.getString(key) ?? defaultValue) as T;
    throw UnsupportedError('loadSetting - Unsupported type for shared preferences');
  }

  /// Save a specific setting by key.
  static Future<void> saveSetting<T>(String key, T value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value is bool) { await prefs.setBool(key, value);
    } else if (value is int) { await prefs.setInt(key, value);
    } else if (value is double) { await prefs.setDouble(key, value);
    } else if (value is String) { await prefs.setString(key, value);
    } else { throw UnsupportedError('saveSetting - Unsupported type for shared preferences');}
  }
}
