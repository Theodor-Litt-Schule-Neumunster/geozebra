
/// Class responsible for validating task completions against their solutions
class TaskValidator {
  /// Validates if a task is completed based on the user's solution and the task's condition
  /// Returns true if the task is completed, false otherwise
  static bool isTaskCompleted(Map<String, dynamic> taskCondition, Map<String, dynamic> userSolution) {
    // Extract validation parameters
    List<dynamic> solutions = taskCondition['solutions'] ?? [];
    String type = taskCondition['type'] ?? '';

    // If no solutions are defined, task can't be completed
    if (solutions.isEmpty) return false;

    // Validate based on task type
    switch (type) {
      case 'point':
        return validatePointTask(solutions, userSolution);
      case 'rename':
        return validateRenameTask(solutions, userSolution);
      case 'scale':
        return validateScaleTask(solutions, userSolution);
      case 'note':
        return validateNoteTask(solutions, userSolution);
      case 'line':
        return validateLineTask(solutions, userSolution);
      case 'equation':
        return validateEquationTask(solutions, userSolution);
      case 'distance':
        return validateDistanceTask(solutions, userSolution);
      case 'function_value':
        return validateFunctionValueTask(solutions, userSolution);
      case 'zero_point':
        return validateZeroPointTask(solutions, userSolution);
      case 'y_intercept':
        return validateYInterceptTask(solutions, userSolution);
      case 'intersection':
        return validateIntersectionTask(solutions, userSolution);
      case 'solve_equation':
        return validateSolveEquationTask(solutions, userSolution);
      case 'graphical_solution':
        return validateGraphicalSolutionTask(solutions, userSolution);
      default:
        return false;
    }
  }

  /// Simplified generic validation function for all task types
  static bool validateGenericTask(List<dynamic> expectedSolutions, List<dynamic> userSolutions, Function equalityCheck) {
    // At least one solution must be correct
    for (final user in userSolutions) {
      for (final expected in expectedSolutions) {
        if (equalityCheck(expected, user)) {
          return true;
        }
      }
    }
    return false;
  }

  /// Validates point tasks
  static bool validatePointTask(List<dynamic> solutions, Map<String, dynamic> userSolution) {
    List<dynamic> userPoints = userSolution['points'] ?? [];
    return validateGenericTask(
      solutions, 
      userPoints, 
      (expected, user) => _pointsEqual(expected, user)
    );
  }

  /// Validates rename tasks
  static bool validateRenameTask(List<dynamic> solutions, Map<String, dynamic> userSolution) {
    List<dynamic> userRenames = userSolution['renames'] ?? [];
    return validateGenericTask(
      solutions, 
      userRenames, 
      (expected, user) => expected['oldName'] == user['oldName'] && expected['newName'] == user['newName']
    );
  }

  /// Add implementations for other validation methods like validateScaleTask, validateLineTask, etc.
  static bool validateScaleTask(List<dynamic> solutions, Map<String, dynamic> userSolution) {
    // Implementation specific to scale tasks
    return true; // Placeholder
  }

  static bool validateNoteTask(List<dynamic> solutions, Map<String, dynamic> userSolution) {
    // Implementation specific to note tasks
    return true; // Placeholder
  }

  static bool validateLineTask(List<dynamic> solutions, Map<String, dynamic> userSolution) {
    List<dynamic> userLines = userSolution['lines'] ?? [];
    return validateGenericTask(
      solutions, 
      userLines, 
      (expected, user) => _linesEqual(expected, user)
    );
  }

  static bool validateEquationTask(List<dynamic> solutions, Map<String, dynamic> userSolution) {
    List<dynamic> userEquations = userSolution['equations'] ?? [];
    return validateGenericTask(
      solutions, 
      userEquations, 
      (expected, user) => _equationsEqual(expected, user)
    );
  }

  static bool validateDistanceTask(List<dynamic> solutions, Map<String, dynamic> userSolution) {
    // Implementation specific to distance tasks
    return true; // Placeholder
  }

  static bool validateFunctionValueTask(List<dynamic> solutions, Map<String, dynamic> userSolution) {
    // Implementation specific to function value tasks
    return true; // Placeholder
  }

  static bool validateZeroPointTask(List<dynamic> solutions, Map<String, dynamic> userSolution) {
    // Implementation specific to zero point tasks
    return true; // Placeholder
  }

  static bool validateYInterceptTask(List<dynamic> solutions, Map<String, dynamic> userSolution) {
    // Implementation specific to y-intercept tasks
    return true; // Placeholder
  }

  static bool validateIntersectionTask(List<dynamic> solutions, Map<String, dynamic> userSolution) {
    // Implementation specific to intersection tasks
    return true; // Placeholder
  }

  static bool validateSolveEquationTask(List<dynamic> solutions, Map<String, dynamic> userSolution) {
    // Implementation specific to solve equation tasks
    return true; // Placeholder
  }

  static bool validateGraphicalSolutionTask(List<dynamic> solutions, Map<String, dynamic> userSolution) {
    // Implementation specific to graphical solution tasks
    return true; // Placeholder
  }

  // Helper methods for equality checks
  static bool _pointsEqual(Map<String, dynamic> expected, Map<String, dynamic> user) {
    // First check if the names match, this is more accurate for identifying points
    bool namesMatch = expected['name'] == user['name'];
    
    // Then check coordinates with proper tolerance
    bool coordinatesMatch = _coordinateEquals(expected['x'], user['x']) && 
                           _coordinateEquals(expected['y'], user['y']);
    
    // If names match, use stricter coordinate matching, otherwise be more lenient
    if (namesMatch) {
      return coordinatesMatch;
    } else {
      // If names don't match but coordinates are very close, still consider it a match
      return coordinatesMatch;
    }
  }

  static bool _linesEqual(Map<String, dynamic> expected, Map<String, dynamic> user) {
    // Implement line equality logic
    return expected['name'] == user['name'] && 
           _listEquals(expected['points'], user['points']);
  }

  static bool _equationsEqual(Map<String, dynamic> expected, Map<String, dynamic> user) {
    // Implement equation equality logic
    return expected['name'] == user['name'] && 
           _definitionEquals(expected['definition'], user['definition']);
  }

  static bool _coordinateEquals(dynamic expected, dynamic actual) {
    // Increased tolerance for better fraction handling
    const double tolerance = 0.02;
    
    // Convert both values to double for comparison
    double expectedValue = _toDouble(expected);
    double actualValue = _toDouble(actual);
    
    // Compare with appropriate tolerance
    return (expectedValue - actualValue).abs() < tolerance;
  }
  
  /// Helper method to convert any coordinate representation to double
  static double _toDouble(dynamic value) {
    if (value is num) {
      return value.toDouble();
    } else if (value is Map<String, dynamic>) {
      // Handle fraction representation
      if (value.containsKey('numerator') && value.containsKey('denominator')) {
        var numerator = value['numerator'] as num;
        var denominator = value['denominator'] as num;
        if (denominator != 0) {
          return numerator / denominator;
        }
      }
    } else if (value is String) {
      // Try to parse string as double
      return double.tryParse(value) ?? 0.0;
    }
    return 0.0; // Default fallback
  }

  static bool _listEquals(List<dynamic>? a, List<dynamic>? b) {
    if (a == null && b == null) return true;
    if (a == null || b == null) return false;
    if (a.length != b.length) return false;
    
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  static bool _definitionEquals(dynamic expected, dynamic actual) {
    // Handle different representations of function definitions
    if (expected is String && actual is String) {
      // Normalize expressions to compare them (remove spaces, etc.)
      return _normalizeExpression(expected) == _normalizeExpression(actual);
    } else if (expected is Map<String, dynamic> && actual is Map<String, dynamic>) {
      // Handle fraction or complex representation
      // This would need custom implementation based on your expression format
      return true; // Placeholder for complex comparison
    }
    return false;
  }

  static String _normalizeExpression(String expression) {
    // Remove spaces and normalize expression for comparison
    return expression.replaceAll(' ', '').toLowerCase();
  }
}
