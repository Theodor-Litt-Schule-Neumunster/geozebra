import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/lesson.dart';
import '../models/task.dart';

class LessonService {
  static final LessonService instance = LessonService._init();
  static Database? _database;

  LessonService._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('lessons.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE Lessons (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT NOT NULL,
        geogebra_url TEXT NOT NULL,
        difficulty INTEGER NOT NULL DEFAULT 1,
        required_previous_lesson INTEGER DEFAULT NULL,
        completion_count INTEGER DEFAULT 0
      )
    ''');

    await db.execute('''
      CREATE TABLE Tasks (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        lesson_id INTEGER NOT NULL,
        title TEXT NOT NULL,
        task_type TEXT NOT NULL,
        correct_answer TEXT,
        is_bonus INTEGER NOT NULL DEFAULT 0,
        FOREIGN KEY (lesson_id) REFERENCES Lessons(id) ON DELETE CASCADE
      )
    ''');

    await loadLessonsFromJSON(db);
  }

  Future<void> loadLessonsFromJSON(Database db) async {
    final String response = await rootBundle.loadString('assets/data/lessons.json');
    final List<dynamic> lessonList = json.decode(response);

    for (var lessonData in lessonList) {
      int lessonId = await db.insert('Lessons', {
        'title': lessonData['title'],
        'description': lessonData['description'],
        'geogebra_url': lessonData['geogebra_url'],
        'difficulty': lessonData['difficulty'],
        'required_previous_lesson': lessonData['required_previous_lesson'],
      });

      for (var taskData in lessonData['tasks']) {
        await db.insert('Tasks', {
          'lesson_id': lessonId,
          'title': taskData['title'],
          'task_type': taskData['task_type'],
          'correct_answer': taskData['correct_answer'],
          'is_bonus': taskData['is_bonus'] ? 1 : 0,
        });
      }
    }
  }
}
