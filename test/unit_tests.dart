import 'package:flutter_test/flutter_test.dart';
import 'package:geozebra_app/models/class_model.dart';

void main() {
  group('Aufgaben Model Tests', () {
    test('Task.fromJson erstellt Task mit korrekten Werten', () {
      final json = {
        'taskId': 'task_1',
        'taskDescription': 'Test Beschreibung',
        'taskShortDescription': 'Kurzbeschreibung',
        'taskCondition': {'key': 'value'}
      };

      final task = Task.fromJson(json);

      expect(task.id, 'task_1');
      expect(task.description, 'Test Beschreibung');
      expect(task.shortDescription, 'Kurzbeschreibung');
      expect(task.condition, {'key': 'value'});
    });

    test('Task.toJson konvertiert Task in korrektes JSON Format', () {
      final task = Task(
        id: 'task_1',
        description: 'Test Beschreibung',
        shortDescription: 'Kurzbeschreibung',
        condition: {'key': 'value'},
      );

      final json = task.toJson();

      expect(json['taskId'], 'task_1');
      expect(json['taskDescription'], 'Test Beschreibung');
      expect(json['taskShortDescription'], 'Kurzbeschreibung');
      expect(json['taskCondition'], {'key': 'value'});
    });
  });

  group('Lektion Model Tests', () {
    test('Lesson.fromJson erstellt Lesson mit korrekten Werten', () {
      final json = {
        'lessonId': 'lesson_1',
        'lessonTitle': 'Test Lektion',
        'description': 'Test Beschreibung',
        'shortDescription': 'Kurzbeschreibung',
        'tasks': [
          {
            'taskDescription': 'Aufgabe 1',
            'taskShortDescription': 'Kurze Aufgabe 1',
            'taskCondition': {}
          }
        ]
      };

      final lesson = Lesson.fromJson(json);

      expect(lesson.lessonId, 'lesson_1');
      expect(lesson.lessonTitle, 'Test Lektion');
      expect(lesson.description, 'Test Beschreibung');
      expect(lesson.shortDescription, 'Kurzbeschreibung');
      expect(lesson.tasks.length, 1);
      expect(lesson.tasks[0].id, 'task_1');
    });

    test('Lesson.toJson konvertiert Lesson in korrektes JSON Format', () {
      final lesson = Lesson(
        lessonId: 'lesson_1',
        lessonTitle: 'Test Lektion',
        description: 'Test Beschreibung',
        shortDescription: 'Kurzbeschreibung',
        tasks: [
          Task(
            id: 'task_1',
            description: 'Aufgabe 1',
            shortDescription: 'Kurze Aufgabe 1',
            condition: {},
          )
        ],
      );

      final json = lesson.toJson();

      expect(json['lessonId'], 'lesson_1');
      expect(json['lessonTitle'], 'Test Lektion');
      expect(json['description'], 'Test Beschreibung');
      expect(json['shortDescription'], 'Kurzbeschreibung');
      expect(json['tasks'].length, 1);
    });
  });

  group('Klassen Model Tests', () {
    test('ClassModel.fromJson erstellt ClassModel mit korrekten Werten', () {
      final json = {
        'classTitle': 'Test Klasse',
        'classDescription': 'Klassenbeschreibung',
        'classShortDescription': 'Kurze Klassenbeschreibung',
        'lessons': [
          {
            'lessonId': 'lesson_1',
            'lessonTitle': 'Test Lektion',
            'description': 'Lektionsbeschreibung',
            'shortDescription': 'Kurze Lektionsbeschreibung',
            'tasks': []
          }
        ]
      };

      final classModel = ClassModel.fromJson(json);

      expect(classModel.className, 'Test Klasse');
      expect(classModel.classDescription, 'Klassenbeschreibung');
      expect(classModel.classShortDescription, 'Kurze Klassenbeschreibung');
      expect(classModel.lessons.length, 1);
      expect(classModel.lessons[0].lessonId, 'lesson_1');
    });

    test('ClassModel.toJson konvertiert ClassModel in korrektes JSON Format', () {
      final classModel = ClassModel(
        className: 'Test Klasse',
        classDescription: 'Klassenbeschreibung',
        classShortDescription: 'Kurze Klassenbeschreibung',
        lessons: [
          Lesson(
            lessonId: 'lesson_1',
            lessonTitle: 'Test Lektion',
            description: 'Lektionsbeschreibung',
            shortDescription: 'Kurze Lektionsbeschreibung',
            tasks: [],
          )
        ],
      );

      final json = classModel.toJson();

      expect(json['classTitle'], 'Test Klasse');
      expect(json['classDescription'], 'Klassenbeschreibung');
      expect(json['classShortDescription'], 'Kurze Klassenbeschreibung');
      expect(json['lessons'].length, 1);
    });
  });
}