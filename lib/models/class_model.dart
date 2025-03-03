class Task {
  final String id;
  final String description;
  final String shortDescription;
  final Map<String, dynamic> condition;
  bool showDetails;

  Task({
    required this.id,
    required this.description,
    required this.shortDescription,
    required this.condition,
    this.showDetails = false,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['taskId'] ?? json['id'],
      description: json['taskDescription'] ?? json['description'],
      shortDescription: json['taskShortDescription'] ??
          json['shortDescription'] ??
          json['description'],
      condition: json['taskCondition'] ?? {},
      showDetails: json['showDetails'] ?? false, // Ensure default value
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'taskId': id,
      'taskDescription': description,
      'taskShortDescription': shortDescription,
      'taskCondition': condition,
      'showDetails': showDetails,
    };
  }
}

class TextSection {
  final String header;
  final String subHeader;
  final String content;

  TextSection({
    required this.header,
    required this.subHeader,
    required this.content,
  });

  factory TextSection.fromJson(Map<String, dynamic> json) {
    return TextSection(
      header: json['header'],
      subHeader: json['subHeader'],
      content: json['content'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'header': header,
      "subHeader": subHeader,
      'content': content,
    };
  }
}

class Lesson {
  final String lessonId;
  final String lessonTitle;
  final String description;
  final String shortDescription;

  final bool showRechner;

  final List<Task> tasks;
  final List<TextSection> textSections;

  Lesson({
    required this.lessonId,
    required this.lessonTitle,
    required this.description,
    required this.shortDescription,
    required this.tasks,
    required this.textSections,
    required this.showRechner,
  });

  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      lessonId: json['lessonId'] ?? 'no_id_given',
      lessonTitle: json['lessonTitle'] ?? 'Kein Titel.',
      description: json['description'] ?? 'Keine Beschreibung.',
      shortDescription: json['shortDescription'] ?? json['description'] ?? 'Keine Kurzbeschreibung.',

      showRechner: json['showRechner'] ?? true,

      tasks: json['tasks'] != null && (json['tasks'] as List).isNotEmpty
          ? (json['tasks'] as List).map((task) => Task.fromJson(task)).toList()
          : [],

      textSections: json['textSections'] != null && (json['textSections'] as List).isNotEmpty
          ? (json['textSections'] as List).map((section) => TextSection.fromJson(section)).toList()
          : [],
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
  final String classId;
  final String className;
  final String classDescription;
  final String classShortDescription;
  final List<Lesson> lessons;

  ClassModel({
    required this.classId,
    required this.className,
    required this.lessons,
    required this.classDescription,
    required this.classShortDescription,
  });

  factory ClassModel.fromJson(Map<String, dynamic> json) {
    return ClassModel(
      classId: json['classId'],
      className: json['classTitle'],
      classDescription: json['classDescription'],
      classShortDescription: json['classShortDescription'],
      lessons: (json['lessons'] as List)
          .map((lesson) => Lesson.fromJson(lesson))
          .toList(),
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
