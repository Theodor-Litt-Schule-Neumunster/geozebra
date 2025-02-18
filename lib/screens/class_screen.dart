import 'package:flutter/material.dart';
import '../models/class_model.dart';
import 'lesson_screen.dart';

class ClassScreen extends StatelessWidget {
  final ClassModel classModel;

  const ClassScreen({super.key, required this.classModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(classModel.className)),
      body: ListView.builder(
        itemCount: classModel.lessons.length,
        itemBuilder: (context, index) {
          final lesson = classModel.lessons[index];

          return ListTile(
            title: Text(lesson.lessonTitle),
            subtitle: Text(lesson.shortDescription),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LessonScreen(lesson: lesson),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
