import 'package:geozebra_app/utils/task_validator.dart';

class LessonsProvider {
  List<String> classFiles = [
    'm1_points',
    'm2_lines',
    'm3_functions',
    'm4_equations',
    'm5_final_test',
  ];

  List<String> getAllClassFiles() {
    return classFiles.map((file) => 'assets/classes/$file.json').toList();
  }
  
  /// Validates whether a user's solution completes a task
  bool isTaskCompleted(Map<String, dynamic> taskCondition, Map<String, dynamic> userSolution) {
    return TaskValidator.isTaskCompleted(taskCondition, userSolution);
  }
}
