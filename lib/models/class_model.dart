class Task {
  final String id;
  final String description;
  final String shortDescription;
  final Map<String, dynamic> condition;

  Task({
    required this.id,
    required this.description,
    required this.shortDescription,
    required this.condition,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['taskId'] ?? json['id'],
      description: json['taskDescription'] ?? json['description'],
      shortDescription: json['taskShortDescription'] ?? json['shortDescription'] ?? json['description'],
      condition: json['taskCondition'] ?? {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'taskId': id,
      'taskDescription': description,
      'taskShortDescription': shortDescription,
      'taskCondition': condition,
    };
  }
}

class Lesson {
  final String lessonId;
  final String lessonTitle;
  final String description;
  final String shortDescription;
  final List<Task> tasks;

  Lesson({
    required this.lessonId,
    required this.lessonTitle,
    required this.description,
    required this.shortDescription,
    required this.tasks,
  });

  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      lessonId: json['lessonId'],
      lessonTitle: json['lessonTitle'],
      description: json['description'],
      shortDescription: json['shortDescription'] ?? json['description'],
      tasks: (json['tasks'] as List).map((task) => Task.fromJson(task)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lessonId': lessonId,
      'lessonTitle': lessonTitle,
      'description': description,
      'shortDescription': shortDescription,
      'tasks': tasks.map((task) => task.toJson()).toList(),
    };
  }
}

class ClassModel {
  final String className;
  final String classDescription;
  final String classShortDescription;
  final List<Lesson> lessons;

  ClassModel({required this.className, required this.lessons,required this.classDescription,required this.classShortDescription});

  factory ClassModel.fromJson(Map<String, dynamic> json) {
    return ClassModel(
      className: json['classTitle'] ?? json['className'],
      classDescription: json['classDescription'],
      classShortDescription: json['classShortDescription'] ?? json['classShortDescription'],
      lessons: (json['lessons'] as List).map((lesson) => Lesson.fromJson(lesson)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'classTitle': className,
      'classDescription': classDescription,
      'classShortDescription': classShortDescription,
      'lessons': lessons.map((lesson) => lesson.toJson()).toList(),
    };
  }
}
