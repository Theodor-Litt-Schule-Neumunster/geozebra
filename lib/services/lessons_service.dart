import 'package:shared_preferences/shared_preferences.dart';

class LessonService {
  static const String enrolledClassesKey = 'enrolledClasses';
  static const String bookmarkedClassesKey = 'bookmarkedClasses';

  Future<void> enrollInClass(String classId) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> enrolledClasses = prefs.getStringList(enrolledClassesKey) ?? [];
    if (!enrolledClasses.contains(classId)) {
      enrolledClasses.add(classId);
      await prefs.setStringList(enrolledClassesKey, enrolledClasses);
    }
  }

  Future<List<String>> getEnrolledClasses() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(enrolledClassesKey) ?? [];
  }

  Future<void> unenrollFromClass(String classId) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> enrolledClasses = prefs.getStringList(enrolledClassesKey) ?? [];
    if (enrolledClasses.contains(classId)) {
      enrolledClasses.remove(classId);
      await prefs.setStringList(enrolledClassesKey, enrolledClasses);
    }
  }


  Future<void> bookmarkClass(String classId) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> bookmarkedClasses = prefs.getStringList(bookmarkedClassesKey) ?? [];
    if (!bookmarkedClasses.contains(classId)) {
      bookmarkedClasses.add(classId);
      await prefs.setStringList(bookmarkedClassesKey, bookmarkedClasses);
    }
  }

  Future<void> unbookmarkClass(String classId) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> bookmarkedClasses = prefs.getStringList(bookmarkedClassesKey) ?? [];
    if (bookmarkedClasses.contains(classId)) {
      bookmarkedClasses.remove(classId);
      await prefs.setStringList(bookmarkedClassesKey, bookmarkedClasses);
    }
  }

  Future<List<String>> getBookmarkedClasses() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(bookmarkedClassesKey) ?? [];
  }
}
