class Task {
  final int id;
  final int lessonId;
  final String title;
  final int progress; // Task progress (e.g., steps completed)
  final bool completed; // ✅ Add this property

  Task({
    required this.id,
    required this.lessonId,
    required this.title,
    required this.progress,
    required this.completed, // ✅ Initialize it
  });

  /// ✅ **Convert JSON/DB data to a Task object**
  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      lessonId: map['lesson_id'],
      title: map['title'],
      progress: map['progress'] ?? 0,
      completed: (map['completed'] ?? 0) == 1, // ✅ Convert 1/0 to bool
    );
  }

  /// ✅ **Convert Task object to JSON/DB format**
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'lesson_id': lessonId,
      'title': title,
      'progress': progress,
      'completed': completed ? 1 : 0, // ✅ Convert bool to 1/0
    };
  }
}
