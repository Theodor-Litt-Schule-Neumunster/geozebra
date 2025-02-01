import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task.dart';
import '../providers/lesson_provider.dart';

class TaskListWidget extends StatelessWidget {
  final List<Task> tasks;

  const TaskListWidget(this.tasks, {super.key});

  @override
  Widget build(BuildContext context) {
    final lessonProvider = Provider.of<LessonProvider>(context);

    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        final isCompleted = lessonProvider.taskCompletion[task.id] ?? false;

        return ListTile(
          title: Text(task.title),
          // subtitle: task.isBonus ? Text("Bonus Task", style: TextStyle(color: Colors.orange)) : null,
          trailing: isCompleted ? Icon(Icons.check_circle, color: Colors.green) : Icon(Icons.circle_outlined),
          onTap: () {
            lessonProvider.markTaskComplete(task.id);
          },
        );
      },
    );
  }
}
