import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('geozebra.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'TEXT PRIMARY KEY';
    const textType = 'TEXT NOT NULL';
    const blobType = 'BLOB'; // Use BLOB for larger text data
    const boolType = 'INTEGER NOT NULL';
    const integerType = 'INTEGER NOT NULL';

    // Table to track lesson progress
    await db.execute('''
    CREATE TABLE lesson_progress (
      lessonId $idType,
      classId $textType,
      isCompleted $boolType,
      completionPercent $integerType,
      lastAccessed $textType
    )
    ''');

    // Table to track individual task completions
    await db.execute('''
    CREATE TABLE task_progress (
      taskId $idType,
      lessonId $textType,
      isCompleted $boolType,
      lastCompleted $textType
    )
    ''');

    // Table to track calculator settings/state - using BLOB for large Base64 strings
    await db.execute('''
    CREATE TABLE calculator_state (
      id $idType,
      state $blobType,
      lastUpdated $textType
    )
    ''');
  }

  // LESSON PROGRESS METHODS
  Future<int> saveLessonProgress(Map<String, dynamic> progress) async {
    final db = await instance.database;
    
    // Check if the record already exists
    final existing = await db.query(
      'lesson_progress',
      where: 'lessonId = ?',
      whereArgs: [progress['lessonId']]
    );
    
    if (existing.isNotEmpty) {
      return await db.update(
        'lesson_progress',
        progress,
        where: 'lessonId = ?',
        whereArgs: [progress['lessonId']]
      );
    } else {
      return await db.insert('lesson_progress', progress);
    }
  }

  Future<Map<String, dynamic>?> getLessonProgress(String lessonId) async {
    final db = await instance.database;
    
    final maps = await db.query(
      'lesson_progress',
      where: 'lessonId = ?',
      whereArgs: [lessonId],
    );
    
    if (maps.isNotEmpty) {
      return maps.first;
    }
    return null;
  }

  Future<List<Map<String, dynamic>>> getAllLessonProgress() async {
    final db = await instance.database;
    return await db.query('lesson_progress');
  }

  // TASK PROGRESS METHODS
  Future<int> saveTaskProgress(Map<String, dynamic> task) async {
    final db = await instance.database;
    
    // Check if the record already exists
    final existing = await db.query(
      'task_progress',
      where: 'taskId = ?',
      whereArgs: [task['taskId']]
    );
    
    if (existing.isNotEmpty) {
      return await db.update(
        'task_progress',
        task,
        where: 'taskId = ?',
        whereArgs: [task['taskId']]
      );
    } else {
      return await db.insert('task_progress', task);
    }
  }

  Future<List<Map<String, dynamic>>> getTasksProgressForLesson(String lessonId) async {
    final db = await instance.database;
    
    return await db.query(
      'task_progress',
      where: 'lessonId = ?',
      whereArgs: [lessonId],
    );
  }

  // CALCULATOR STATE METHODS - Updated to handle large Base64 strings
  Future<int> saveCalculatorState(Map<String, dynamic> state) async {
    final db = await instance.database;
    
    // Always use the same ID for calculator state
    state['id'] = 'calculator_state';
    
    // Check if the record already exists
    final existing = await db.query(
      'calculator_state',
      where: 'id = ?',
      whereArgs: ['calculator_state']
    );
    
    if (existing.isNotEmpty) {
      return await db.update(
        'calculator_state',
        state,
        where: 'id = ?',
        whereArgs: ['calculator_state']
      );
    } else {
      return await db.insert('calculator_state', state);
    }
  }

  Future<Map<String, dynamic>?> getCalculatorState() async {
    final db = await instance.database;
    
    final maps = await db.query(
      'calculator_state',
      where: 'id = ?',
      whereArgs: ['calculator_state'],
    );
    
    if (maps.isNotEmpty) {
      return maps.first;
    }
    return null;
  }

  // Close database
  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
