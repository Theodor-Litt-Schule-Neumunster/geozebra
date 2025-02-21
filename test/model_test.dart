import 'package:flutter_test/flutter_test.dart';
import 'package:geozebra_app/models/class_model.dart';

void main() {
  group('Task', () {
    test('fromJson creates a Task from JSON', () {
      final json = {
        'taskId': '1',
        'taskDescription': 'Description',
        'taskShortDescription': 'Short Description',
        'taskCondition': {'key': 'value'},
      };
      final task = Task.fromJson(json);

      expect(task.id, '1');
      expect(task.description, 'Description');
      expect(task.shortDescription, 'Short Description');
      expect(task.condition, {'key': 'value'});
    });

    test('toJson converts a Task to JSON', () {
      final task = Task(
        id: '1',
        description: 'Description',
        shortDescription: 'Short Description',
        condition: {'key': 'value'},
      );
      final json = task.toJson();

      expect(json, {
        'taskId': '1',
        'taskDescription': 'Description',
        'taskShortDescription': 'Short Description',
        'taskCondition': {'key': 'value'},
      });
    });
  });

  group('Lesson', () {
    test('fromJson creates a Lesson from JSON', () {
      final json = {
        'lessonId': '1',
        'lessonTitle': 'Title',
        'description': 'Description',
        'shortDescription': 'Short Description',
        'tasks': [
          {
            'taskId': '1',
            'taskDescription': 'Task Description',
            'taskShortDescription': 'Task Short Description',
            'taskCondition': {'key': 'value'},
          }
        ],
      };
      final lesson = Lesson.fromJson(json);

      expect(lesson.lessonId, '1');
      expect(lesson.lessonTitle, 'Title');
      expect(lesson.description, 'Description');
      expect(lesson.shortDescription, 'Short Description');
      expect(lesson.tasks.length, 1);
      expect(lesson.tasks[0].id, '1');
    });

    test('toJson converts a Lesson to JSON', () {
      final lesson = Lesson(
        lessonId: '1',
        lessonTitle: 'Title',
        description: 'Description',
        shortDescription: 'Short Description',
        tasks: [
          Task(
            id: '1',
            description: 'Task Description',
            shortDescription: 'Task Short Description',
            condition: {'key': 'value'},
          )
        ],
      );
      final json = lesson.toJson();

      expect(json, {
        'lessonId': '1',
        'lessonTitle': 'Title',
        'description': 'Description',
        'shortDescription': 'Short Description',
        'tasks': [
          {
            'taskId': '1',
            'taskDescription': 'Task Description',
            'taskShortDescription': 'Task Short Description',
            'taskCondition': {'key': 'value'},
          }
        ],
      });
    });
  });

  group('ClassModel', () {
    test('fromJson creates a ClassModel from JSON', () {
      final json = {
        'classId': '1',
        'classTitle': 'Title',
        'classDescription': 'Description',
        'classShortDescription': 'Short Description',
        'lessons': [
          {
            'lessonId': '1',
            'lessonTitle': 'Lesson Title',
            'description': 'Lesson Description',
            'shortDescription': 'Lesson Short Description',
            'tasks': [
              {
                'taskId': '1',
                'taskDescription': 'Task Description',
                'taskShortDescription': 'Task Short Description',
                'taskCondition': {'key': 'value'},
              }
            ],
          }
        ],
      };
      final classModel = ClassModel.fromJson(json);

      expect(classModel.classId, '1');
      expect(classModel.className, 'Title');
      expect(classModel.classDescription, 'Description');
      expect(classModel.classShortDescription, 'Short Description');
      expect(classModel.lessons.length, 1);
      expect(classModel.lessons[0].lessonId, '1');
    });

    test('toJson converts a ClassModel to JSON', () {
      final classModel = ClassModel(
        classId: '1',
        className: 'Title',
        classDescription: 'Description',
        classShortDescription: 'Short Description',
        lessons: [
          Lesson(
            lessonId: '1',
            lessonTitle: 'Lesson Title',
            description: 'Lesson Description',
            shortDescription: 'Lesson Short Description',
            tasks: [
              Task(
                id: '1',
                description: 'Task Description',
                shortDescription: 'Task Short Description',
                condition: {'key': 'value'},
              )
            ],
          )
        ],
      );
      final json = classModel.toJson();

      expect(json, {
        'classTitle': 'Title',
        'classDescription': 'Description',
        'classShortDescription': 'Short Description',
        'lessons': [
          {
            'lessonId': '1',
            'lessonTitle': 'Lesson Title',
            'description': 'Lesson Description',
            'shortDescription': 'Lesson Short Description',
            'tasks': [
              {
                'taskId': '1',
                'taskDescription': 'Task Description',
                'taskShortDescription': 'Task Short Description',
                'taskCondition': {'key': 'value'},
              }
            ],
          }
        ],
      });
    });
  });
}