import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LessonProgressService {
  static const String _key = 'startedLessons';

  /// Retrieve the list of started lesson IDs.
  Future<List<String>> getStartedLessons() async {
    final prefs = await SharedPreferences.getInstance();
    String? lessonsJson = prefs.getString(_key);
    if (lessonsJson != null) {
      List<dynamic> lessonsList = json.decode(lessonsJson);
      return lessonsList.cast<String>();
    }
    return [];
  }

  /// Add a lesson to the list of started lessons if it isn't already saved.
  Future<void> addStartedLesson(String lessonId) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> startedLessons = await getStartedLessons();
    if (!startedLessons.contains(lessonId)) {
      startedLessons.add(lessonId);
      await prefs.setString(_key, json.encode(startedLessons));
    }
  }
}
