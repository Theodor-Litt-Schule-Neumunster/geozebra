import 'task.dart';

class Lesson {
  final int id;
  final String title;
  final String description;
  final int difficulty;
  final int? requiredPreviousLesson;
  int completionCount;
  final List<Task> tasks;
  final bool isBonus;

  Lesson({
    required this.id,
    required this.title,
    required this.description,
    required this.difficulty,
    this.requiredPreviousLesson,
    this.completionCount = 0,
    required this.tasks,
    this.isBonus = false,
  });

  /// ✅ Convert SQLite data to `Lesson` object
  factory Lesson.fromMap(Map<String, dynamic> map, List<Task> lessonTasks) {
    return Lesson(
      id: map['id'] as int,
      title: map['title'] as String,
      description: map['description'] as String,
      difficulty: map['difficulty'] as int,
      requiredPreviousLesson: map['requiredPreviousLesson'] as int?,
      completionCount: map['completionCount'] as int? ?? 0,
      tasks: lessonTasks,
      isBonus: (map['isBonus'] as int? ?? 0) == 1,
    );
  }

  /// ✅ Convert `Lesson` object to SQLite-compatible format
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'difficulty': difficulty,
      'requiredPreviousLesson': requiredPreviousLesson,
      'completionCount': completionCount,
      'isBonus': isBonus ? 1 : 0,
    };
  }
}
