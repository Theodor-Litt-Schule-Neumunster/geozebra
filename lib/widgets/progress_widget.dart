import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/lesson.dart';
import '../providers/lesson_provider.dart';
import '../screens/lessondetail_screen.dart';

class ProgressWidget extends StatelessWidget {
  final Lesson lesson;

  const ProgressWidget(this.lesson, {super.key});

  @override
  Widget build(BuildContext context) {
    final lessonProvider = Provider.of<LessonProvider>(context, listen: false);
    double progress = lessonProvider.getLessonProgress();

    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        title: Text(lesson.title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LinearProgressIndicator(value: progress),
            Text("${(progress * 100).toStringAsFixed(0)}% completed"),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: () {
            _showRestartDialog(context, lessonProvider);
          },
        ),
        onTap: () {
          lessonProvider.selectLesson(lesson);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LessonDetailScreen()),
          );
        },
      ),
    );
  }

  void _showRestartDialog(BuildContext context, LessonProvider lessonProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Restart Lesson"),
        content: const Text("Are you sure you want to restart this lesson? Your progress will be reset."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              lessonProvider.resetLessonProgress(lesson.id);
              Navigator.pop(context);
            },
            child: const Text("Restart"),
          ),
        ],
      ),
    );
  }
}
