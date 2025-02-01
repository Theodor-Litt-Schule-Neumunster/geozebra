import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/lesson_provider.dart';
import '../widgets/tasklist_widget.dart';
import '../widgets/tasktree_widget.dart';

class LessonDetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final lessonProvider = Provider.of<LessonProvider>(context);
    final lesson = lessonProvider.selectedLesson;

    if (lesson == null) return Scaffold(body: Center(child: Text("No lesson selected")));

    return Scaffold(
      appBar: AppBar(title: Text(lesson.title)),
      body: Column(
        children: [
          LinearProgressIndicator(
            value: lessonProvider.getLessonProgress(),
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
          ),
          Expanded(
            child: TaskListWidget(lesson.tasks),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: Text("Task Tree"),
                    content: TaskTreeWidget(lesson.tasks),
                  ),
                );
              },
              child: Text("View Task Tree"),
            ),
          ),
        ],
      ),
    );
  }
}
