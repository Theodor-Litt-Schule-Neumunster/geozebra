import 'dart:convert';

class GeogebraService {
  static bool validateTask(int taskId, String geogebraData) {
    try {
      final Map<String, dynamic> data = json.decode(geogebraData);

      switch (taskId) {
        case 1: // Task: Create a point
          return data.containsKey("A"); // Check if point "A" exists
        case 2: // Task: Draw a line
          return data.containsKey("line1"); // Check if "line1" exists
        default:
          return false;
      }
    } catch (e) {
      print("❌ Error validating task: $e");
      return false;
    }
  }
}
