import 'package:shared_preferences/shared_preferences.dart';
import 'package:geozebra_app/services/progress_service.dart';
import 'package:geozebra_app/models/progress_models.dart';

class LessonService {
  static const String enrolledClassesKey = 'enrolledClasses';
  static const String bookmarkedClassesKey = 'bookmarkedClasses';
  final ProgressService _progressService = ProgressService();

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

  Future<void> saveLessonProgress(String lessonId, String classId, bool isCompleted, int completionPercent) async {
    final now = DateTime.now().toIso8601String();
    final progress = LessonProgressModel(
      lessonId: lessonId,
      classId: classId,
      isCompleted: isCompleted,
      completionPercent: completionPercent,
      lastAccessed: now,
    );
    
    await _progressService.saveLessonProgress(progress);
  }

  Future<Map<String, dynamic>?> getLessonProgress(String lessonId) async {
    final progress = await _progressService.getLessonProgress(lessonId);
    if (progress != null) {
      return progress.toMap();
    }
    return null;
  }

  Future<List<Map<String, dynamic>>> getAllLessonsProgress() async {
    final progressList = await _progressService.getAllLessonProgress();
    return progressList.map((progress) => progress.toMap()).toList();
  }

  Future<void> saveTaskProgress(String taskId, String lessonId, bool isCompleted) async {
    final now = DateTime.now().toIso8601String();
    final task = TaskProgressModel(
      taskId: taskId,
      lessonId: lessonId,
      isCompleted: isCompleted,
      lastCompleted: now,
    );
    
    await _progressService.saveTaskProgress(task);
  }

  Future<List<Map<String, dynamic>>> getTasksProgressForLesson(String lessonId) async {
    final tasks = await _progressService.getTasksProgressForLesson(lessonId);
    return tasks.map((task) => task.toMap()).toList();
  }

  Future<void> saveCalculatorState(String state) async {
    final now = DateTime.now().toIso8601String();
    final calculatorState = CalculatorStateModel(
      id: 'calculator_state',
      state: state,
      lastUpdated: now,
    );
    
    await _progressService.saveCalculatorState(calculatorState);
  }

  Future<String?> getCalculatorState() async {
    final state = await _progressService.getCalculatorState('calculator_state');
    return state?.state;
  }

  Future<int> calculateLessonCompletionPercent(String lessonId, Map<String, bool> taskStatus) async {
    final totalTasks = taskStatus.length;
    if (totalTasks == 0) return 0;
    
    final completedTasks = taskStatus.values.where((isCompleted) => isCompleted).length;
    return (completedTasks / totalTasks * 100).round();
  }

  Future<void> clearAllProgress() async {
    await _progressService.clearAllProgress();
  }
}
