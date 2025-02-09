import 'package:flutter/material.dart';
import '../models/class_model.dart';
import 'lesson_screen.dart';

class ClassScreen extends StatefulWidget {
  final ClassModel classModel;
  const ClassScreen({super.key, required this.classModel});

  @override
  State<ClassScreen> createState() => _ClassScreenState();
}

class _ClassScreenState extends State<ClassScreen> {
  Lesson? selectedLesson;

  void _showLessonDetails(Lesson lesson) {
    setState(() {
      selectedLesson = lesson;
    });
  }

  @override

  // TODO: Implement a proper view for the lessons
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.classModel.className)),
      body: Row(
        children: [
          Expanded(
            flex: 2,
            child: ListView.builder(
              itemCount: widget.classModel.lessons.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(widget.classModel.lessons[index].lessonTitle),
                  onTap: () => _showLessonDetails(widget.classModel.lessons[index]),
                );
              },
            ),
          ),
          Expanded(
            flex: 3,
            child: selectedLesson == null
                ? const Center(child: Text("Wähle eine Lektion aus"))
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          selectedLesson!.lessonTitle,
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Moin")
                        // child: Text(selectedLesson!.description),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LessonScreen(lesson: selectedLesson!),
                            ),
                          );
                        },
                        child: const Text("Start Lesson"),
                      )
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
