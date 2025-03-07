import 'package:geozebra_app/utils/task_validator.dart';

class LessonsProvider {
  List<String> classFiles = [
    'basic_geogebra',
    'advanced_geogebra',
    'intermediate_geogebra',
    'points',
    'lines',
    'functions',
    'equations',
    'final_test',
    'test_lesson',
  ];

  List<String> getAllClassFiles() {
    return classFiles.map((file) => 'assets/classes/$file.json').toList();
  }
  
  /// Validates whether a user's solution completes a task
  bool isTaskCompleted(Map<String, dynamic> taskCondition, Map<String, dynamic> userSolution) {
    return TaskValidator.isTaskCompleted(taskCondition, userSolution);
  }
}
