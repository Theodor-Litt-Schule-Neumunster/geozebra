import 'package:flutter/material.dart';
import '../models/task.dart';

class TaskTreeWidget extends StatelessWidget {
  final List<Task> tasks;

  const TaskTreeWidget(this.tasks, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: tasks.map((task) {
        return Row(
          children: [
            Icon(Icons.circle, color:  Colors.blue),
            SizedBox(width: 10),
            Text(task.title),
          ],
        );
      }).toList(),
    );
  }
}
