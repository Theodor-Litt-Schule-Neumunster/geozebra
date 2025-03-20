class LessonProgressModel {
  final String lessonId;
  final String classId;
  final bool isCompleted;
  final int completionPercent;
  final String lastAccessed;

  LessonProgressModel({
    required this.lessonId,
    required this.classId,
    required this.isCompleted,
    required this.completionPercent,
    required this.lastAccessed,
  });

  Map<String, dynamic> toMap() {
    return {
      'lessonId': lessonId,
      'classId': classId,
      'isCompleted': isCompleted ? 1 : 0,
      'completionPercent': completionPercent,
      'lastAccessed': lastAccessed,
    };
  }

  factory LessonProgressModel.fromMap(Map<String, dynamic> map) {
    return LessonProgressModel(
      lessonId: map['lessonId'],
      classId: map['classId'],
      isCompleted: map['isCompleted'] == 1,
      completionPercent: map['completionPercent'],
      lastAccessed: map['lastAccessed'],
    );
  }
}

class TaskProgressModel {
  final String taskId;
  final String lessonId;
  final bool isCompleted;
  final String lastCompleted;

  TaskProgressModel({
    required this.taskId,
    required this.lessonId,
    required this.isCompleted,
    required this.lastCompleted,
  });

  Map<String, dynamic> toMap() {
    return {
      'taskId': taskId,
      'lessonId': lessonId,
      'isCompleted': isCompleted ? 1 : 0,
      'lastCompleted': lastCompleted,
    };
  }

  factory TaskProgressModel.fromMap(Map<String, dynamic> map) {
    return TaskProgressModel(
      taskId: map['taskId'],
      lessonId: map['lessonId'],
      isCompleted: map['isCompleted'] == 1,
      lastCompleted: map['lastCompleted'],
    );
  }
}

class CalculatorStateModel {
  final String id;
  final String state;
  final String lastUpdated;

  CalculatorStateModel({
    required this.id,
    required this.state,
    required this.lastUpdated,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'state': state,
      'lastUpdated': lastUpdated,
    };
  }

  factory CalculatorStateModel.fromMap(Map<String, dynamic> map) {
    return CalculatorStateModel(
      id: map['id'],
      state: map['state'],
      lastUpdated: map['lastUpdated'],
    );
  }
}
