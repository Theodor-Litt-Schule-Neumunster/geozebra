import 'package:flutter/material.dart';
import '../models/lesson.dart';
import '../models/task.dart';
import '../services/lesson_service.dart';

class LessonProvider with ChangeNotifier {
  List<Lesson> _lessons = [];
  Lesson? _selectedLesson;
  Map<int, bool> _taskCompletion = {}; // Stores task ID and completion status

  List<Lesson> get lessons => _lessons;
  Lesson? get selectedLesson => _selectedLesson;
  Map<int, bool> get taskCompletion => _taskCompletion;

  Future<void> loadLessons() async {
    final db = await LessonService.instance.database;
    final lessonsData = await db.query("Lessons");
    final tasksData = await db.query("Tasks");

    _lessons = lessonsData.map((lesson) {
      final lessonId = lesson['id'] as int;
      final lessonTasks = tasksData
          .where((task) => task['lesson_id'] == lessonId)
          .map((task) => Task.fromMap(task))
          .toList();
      return Lesson.fromMap(lesson, lessonTasks);
    }).toList();

    notifyListeners();
  }

  Lesson? getLesson(int lessonId) {
    return _lessons.firstWhere((lesson) => lesson.id == lessonId, orElse: () => Lesson(id: lessonId, title: "Unknown", description: "", difficulty: 1, tasks: []));
  }

  void selectLesson(Lesson lesson) {
    _selectedLesson = lesson;
    _taskCompletion.clear();
    for (var task in lesson.tasks) {
      _taskCompletion[task.id] = false;
    }
    notifyListeners();
  }

  void markTaskComplete(int taskId) {
    _taskCompletion[taskId] = true;
    notifyListeners();
  }

  double getLessonProgress() {
    if (_selectedLesson == null || _selectedLesson!.tasks.isEmpty) return 0.0;
    int completedTasks = _taskCompletion.values.where((v) => v).length;
    return completedTasks / _selectedLesson!.tasks.length;
  }

  void resetLessonProgress(int lessonId) {
    _taskCompletion.updateAll((key, value) => false);
    notifyListeners();
  }
}
