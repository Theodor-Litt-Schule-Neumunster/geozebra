import 'package:flutter/foundation.dart';
import 'package:geozebra_app/models/progress_models.dart';
import 'package:geozebra_app/services/progress_service.dart';

class ProgressProvider extends ChangeNotifier {
  final ProgressService _progressService = ProgressService();
  
  List<LessonProgressModel> _lessonProgress = [];
  Map<String, List<TaskProgressModel>> _taskProgress = {};
  CalculatorStateModel? _calculatorState;
  
  List<LessonProgressModel> get lessonProgress => _lessonProgress;
  Map<String, List<TaskProgressModel>> get taskProgress => _taskProgress;
  CalculatorStateModel? get calculatorState => _calculatorState;
  
  // Initialize provider
  Future<void> initialize() async {
    await loadAllLessonProgress();
    await loadCalculatorState();
  }
  
  // Lesson progress methods
  Future<void> loadAllLessonProgress() async {
    _lessonProgress = await _progressService.getAllLessonProgress();
    notifyListeners();
  }
  
  Future<void> saveLessonProgress(
    String lessonId,
    String classId,
    bool isCompleted,
    int completionPercent
  ) async {
    final now = DateTime.now().toIso8601String();
    
    final progress = LessonProgressModel(
      lessonId: lessonId,
      classId: classId,
      isCompleted: isCompleted,
      completionPercent: completionPercent,
      lastAccessed: now,
    );
    
    await _progressService.saveLessonProgress(progress);
    
    // Update local state
    final existingIndex = _lessonProgress.indexWhere((p) => p.lessonId == lessonId);
    if (existingIndex >= 0) {
      _lessonProgress[existingIndex] = progress;
    } else {
      _lessonProgress.add(progress);
    }
    
    notifyListeners();
  }
  
  LessonProgressModel? getLessonProgress(String lessonId) {
    return _lessonProgress.firstWhere(
      (progress) => progress.lessonId == lessonId,
      orElse: () => LessonProgressModel(
        lessonId: lessonId,
        classId: '',
        isCompleted: false,
        completionPercent: 0,
        lastAccessed: DateTime.now().toIso8601String(),
      ),
    );
  }
  
  // Task progress methods
  Future<void> loadTasksForLesson(String lessonId) async {
    final tasks = await _progressService.getTasksProgressForLesson(lessonId);
    _taskProgress[lessonId] = tasks;
    notifyListeners();
  }
  
  Future<void> saveTaskProgress(
    String taskId,
    String lessonId,
    bool isCompleted
  ) async {
    final now = DateTime.now().toIso8601String();
    
    final task = TaskProgressModel(
      taskId: taskId,
      lessonId: lessonId,
      isCompleted: isCompleted,
      lastCompleted: now,
    );
    
    await _progressService.saveTaskProgress(task);
    
    // Update local state
    if (!_taskProgress.containsKey(lessonId)) {
      _taskProgress[lessonId] = [];
    }
    
    final existingIndex = _taskProgress[lessonId]!.indexWhere((t) => t.taskId == taskId);
    if (existingIndex >= 0) {
      _taskProgress[lessonId]![existingIndex] = task;
    } else {
      _taskProgress[lessonId]!.add(task);
    }
    
    notifyListeners();
  }
  
  List<TaskProgressModel> getTasksForLesson(String lessonId) {
    return _taskProgress[lessonId] ?? [];
  }
  
  // Calculator state methods
  Future<void> loadCalculatorState() async {
    _calculatorState = await _progressService.getCalculatorState('calculator_state');
    notifyListeners();
  }
  
  Future<void> saveCalculatorState(String state) async {
    final now = DateTime.now().toIso8601String();
    
    final calculatorState = CalculatorStateModel(
      id: 'calculator_state',
      state: state,
      lastUpdated: now,
    );
    
    await _progressService.saveCalculatorState(calculatorState);
    
    // Update local state
    _calculatorState = calculatorState;
    notifyListeners();
  }
  
  // Calculate lesson completion percent based on tasks
  int calculateCompletionPercent(Map<String, bool> taskStatus) {
    if (taskStatus.isEmpty) return 0;
    
    final completedCount = taskStatus.values.where((status) => status).length;
    return (completedCount / taskStatus.length * 100).round();
  }
  
  // Clear all progress
  Future<void> clearAllProgress() async {
    await _progressService.clearAllProgress();
    
    _lessonProgress = [];
    _taskProgress = {};
    _calculatorState = null;
    
    notifyListeners();
  }
}
