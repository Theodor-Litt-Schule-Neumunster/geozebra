import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  final prefs = SharedPreferences.getInstance();

  Future<T> getValue<T>(String settingKey, T defaultValue) async {
    var lPrefs = await prefs;

    return switch (T) {
      const (bool) => (lPrefs.getBool(settingKey) ?? defaultValue) as T,
      const (int) => (lPrefs.getInt(settingKey) ?? defaultValue) as T,
      const (double) => (lPrefs.getDouble(settingKey) ?? (lPrefs.getInt(settingKey)?.toDouble()) ?? defaultValue) as T,
      const (String) => (lPrefs.getString(settingKey) ?? defaultValue) as T,
      _ => throw UnsupportedError('Unsupported type: ${T.toString()}')
    };
  }

  setValue<T>(String settingKey, T value) async {
    var lPrefs = await prefs;

    return switch (T) {
      const (bool) => lPrefs.setBool(settingKey, value as bool),
      const (int) => lPrefs.setInt(settingKey, value as int),
      const (double) => lPrefs.setDouble(settingKey, value as double),
      const (String) => lPrefs.setString(settingKey, value as String),
      _ => throw UnsupportedError('Unsupported type: ${T.toString()}')
    };
  }

  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
