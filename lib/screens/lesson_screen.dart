import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:provider/provider.dart';
import '../providers/lesson_provider.dart';
import '../services/geogebra_service.dart';

class LessonScreen extends StatefulWidget {
  final int lessonId;

  const LessonScreen({super.key, required this.lessonId});

  @override
  State<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen> {
  WebViewController? _webViewController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final lessonProvider = Provider.of<LessonProvider>(context, listen: false);
      lessonProvider.loadLessons(); // Ensure lessons are loaded
    });

    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel(
        'FlutterChannel',
        onMessageReceived: (JavaScriptMessage message) {
          _handleTaskCompletion(message.message);
        },
      )
      ..loadRequest(Uri.parse('file:///android_asset/flutter_assets/assets/html/rechner.html'));
  }

  void _handleTaskCompletion(String message) {
    final lessonProvider = Provider.of<LessonProvider>(context, listen: false);
    final lesson = lessonProvider.getLesson(widget.lessonId);

    if (lesson == null) {
      print("❌ Error: Lesson not found.");
      return;
    }

    for (var task in lesson.tasks) {
      if (!task.completed && GeogebraService.validateTask(task.id, message)) {
        lessonProvider.markTaskComplete(task.id);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("✅ ${task.title} completed!")),
        );

        setState(() {}); // Update UI
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final lessonProvider = Provider.of<LessonProvider>(context);
    final lesson = lessonProvider.getLesson(widget.lessonId);

    if (lesson == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("Lesson Not Found")),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(lesson.title)),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: _webViewController != null
                ? WebViewWidget(controller: _webViewController!)
                : const Center(child: CircularProgressIndicator()),
          ),
          Expanded(
            flex: 1,
            child: ListView.builder(
              itemCount: lesson.tasks.length,
              itemBuilder: (context, index) {
                final task = lesson.tasks[index];
                return ListTile(
                  title: Text(task.title),
                  trailing: task.completed
                      ? const Icon(Icons.check_circle, color: Colors.green)
                      : const Icon(Icons.hourglass_empty),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
