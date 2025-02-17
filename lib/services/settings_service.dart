import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

class SettingsService {
  Future<T> getValue<T>(String key, T defaultValue) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return (prefs.get(key) ?? defaultValue) as T;
    } catch (e) {
      debugPrint('Error reading settings: $e');
      return defaultValue;
    }
  }

  setValue<T>(String settingKey, T value) async {
    var lPrefs = await SharedPreferences.getInstance();

    return switch (T) {
      const (bool) => lPrefs.setBool(settingKey, value as bool),
      const (int) => lPrefs.setInt(settingKey, value as int),
      const (double) => lPrefs.setDouble(settingKey, value as double),
      const (String) => lPrefs.setString(settingKey, value as String),
      _ => throw UnsupportedError('Unsupported type: ${T.toString()}')
    };
  }
}
