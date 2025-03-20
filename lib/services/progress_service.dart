import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:geozebra_app/models/progress_models.dart';

class ProgressService {
  static final ProgressService _instance = ProgressService._internal();
  static Database? _database;

  factory ProgressService() => _instance;

  ProgressService._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'geozebra_progress.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        // Lesson progress table
        await db.execute('''
          CREATE TABLE lesson_progress(
            lessonId TEXT PRIMARY KEY,
            classId TEXT NOT NULL,
            isCompleted INTEGER NOT NULL,
            completionPercent INTEGER NOT NULL,
            lastAccessed TEXT NOT NULL
          )
        ''');

        // Task progress table
        await db.execute('''
          CREATE TABLE task_progress(
            taskId TEXT PRIMARY KEY,
            lessonId TEXT NOT NULL,
            isCompleted INTEGER NOT NULL,
            lastCompleted TEXT NOT NULL
          )
        ''');

        // Calculator state table
        await db.execute('''
          CREATE TABLE calculator_state(
            id TEXT PRIMARY KEY,
            state BLOB NOT NULL,
            lastUpdated TEXT NOT NULL
          )
        ''');
      },
    );
  }

  // LESSON PROGRESS METHODS
  Future<void> saveLessonProgress(LessonProgressModel progress) async {
    final db = await database;
    
    await db.insert(
      'lesson_progress',
      progress.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<LessonProgressModel?> getLessonProgress(String lessonId) async {
    final db = await database;
    
    final results = await db.query(
      'lesson_progress',
      where: 'lessonId = ?',
      whereArgs: [lessonId],
    );
    
    if (results.isNotEmpty) {
      return LessonProgressModel.fromMap(results.first);
    }
    return null;
  }

  Future<List<LessonProgressModel>> getAllLessonProgress() async {
    final db = await database;
    final results = await db.query('lesson_progress');
    
    return results.map((map) => LessonProgressModel.fromMap(map)).toList();
  }

  // TASK PROGRESS METHODS
  Future<void> saveTaskProgress(TaskProgressModel task) async {
    final db = await database;
    
    await db.insert(
      'task_progress',
      task.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<TaskProgressModel>> getTasksProgressForLesson(String lessonId) async {
    final db = await database;
    
    final results = await db.query(
      'task_progress',
      where: 'lessonId = ?',
      whereArgs: [lessonId],
    );
    
    return results.map((map) => TaskProgressModel.fromMap(map)).toList();
  }

  // CALCULATOR STATE METHODS
  Future<void> saveCalculatorState(CalculatorStateModel state) async {
    final db = await database;
    
    await db.insert(
      'calculator_state',
      state.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<CalculatorStateModel?> getCalculatorState(String id) async {
    final db = await database;
    
    final results = await db.query(
      'calculator_state',
      where: 'id = ?',
      whereArgs: [id],
    );
    
    if (results.isNotEmpty) {
      return CalculatorStateModel.fromMap(results.first);
    }
    return null;
  }

  // Clear progress methods
  Future<void> clearAllProgress() async {
    final db = await database;
    await db.delete('lesson_progress');
    await db.delete('task_progress');
    await db.delete('calculator_state');
  }
}
