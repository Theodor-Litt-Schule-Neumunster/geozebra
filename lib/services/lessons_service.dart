import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LessonService {
  static const String taskStatusKey = "taskStatus";
  static const String overriddenTasksKey = "overriddenTasks";
  static const String geogebraStateKey = "geogebraState";

  /// Load saved task data
  static Future<Map<String, bool>> loadTaskStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final taskData = prefs.getString(taskStatusKey);
    return taskData != null ? Map<String, bool>.from(jsonDecode(taskData)) : {};
  }

  /// Load manually overridden tasks
  static Future<Map<String, bool>> loadOverriddenTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final manualData = prefs.getString(overriddenTasksKey);
    return manualData != null ? Map<String, bool>.from(jsonDecode(manualData)) : {};
  }

  /// Save task status and overridden tasks
  static Future<void> saveTaskData(Map<String, bool> taskStatus, Map<String, bool> overriddenTasks) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(taskStatusKey, jsonEncode(taskStatus));
    await prefs.setString(overriddenTasksKey, jsonEncode(overriddenTasks));
    print("💾 Task data saved.");
  }

  /// Save GeoGebra state (points, lines, etc.)
  static Future<void> saveGeoGebraState(String stateJson) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(geogebraStateKey, stateJson);
    print("💾 GeoGebra state saved.");
  }

  /// Load GeoGebra state
  static Future<String?> loadGeoGebraState() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(geogebraStateKey);
  }
}
