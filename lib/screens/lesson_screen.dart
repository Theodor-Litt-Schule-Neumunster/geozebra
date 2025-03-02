import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:webview_flutter/webview_flutter.dart';
import '../models/class_model.dart';
import '../widgets/defaultappbar_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:geozebra_app/models/theme_model.dart';
import '../widgets/lessonScreen/defaultBody.dart';
import '../widgets/lessonScreen/defaultDrawer.dart';

class LessonScreen extends StatefulWidget {
  final Lesson lesson;
  const LessonScreen({super.key, required this.lesson});

  @override
  State<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen>
    with SingleTickerProviderStateMixin {
  late final WebViewController _controller;
  bool isLoading = true;
  bool minLoadingTimePassed = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  Map<String, bool> taskStatus = {};
  Timer? _taskCheckTimer;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 600),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );

    Timer(Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          minLoadingTimePassed = true;
        });
      }
    });

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (url) {
            if (minLoadingTimePassed) {
              _animationController.forward().then((_) {
                if (mounted) {
                  setState(() {
                    isLoading = false;
                  });
                }
              });
              sendAllTasksToWebView();
              _startTaskCheckLoop();
            } else {
              Timer(Duration(milliseconds: 500), () {
                if (mounted) {
                  _animationController.forward().then((_) {
                    if (mounted) {
                      setState(() {
                        isLoading = false;
                      });
                    }
                  });
                  sendAllTasksToWebView();
                  _startTaskCheckLoop();
                }
              });
            }
          },
        ),
      )
      ..addJavaScriptChannel(
        "taskCompleted",
        onMessageReceived: (message) {
          _updateTaskStatus(message.message);
        },
      )
      ..loadFlutterAsset("assets/html/rechner.html");
  }

  @override
  void dispose() {
    _taskCheckTimer?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  void sendAllTasksToWebView() {
    final tasksJson = jsonEncode(widget.lesson.tasks
        .map((task) => {
              "taskId": task.id,
              "taskDescription": task.description,
              "condition": task.condition
            })
        .toList());

    _controller.runJavaScript("receiveTasksFromFlutter('$tasksJson');");
  }

  void _startTaskCheckLoop() {
    _taskCheckTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      _controller.runJavaScript("sendTaskStatusToFlutter();");
    });
  }

  void _updateTaskStatus(String jsonStatus) {
    try {
      print("🔄 Received task status update: $jsonStatus");
      final Map<String, dynamic> status = jsonDecode(jsonStatus);

      setState(() {
        taskStatus.clear();
        taskStatus
            .addAll(status.map((key, value) => MapEntry(key, value == true)));
      });

      print("✅ Updated taskStatus: $taskStatus");
    } catch (e) {
      print("❌ Error parsing task status: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(title: widget.lesson.lessonTitle),
      endDrawer: widget.lesson.showRechner
          ? DefaultDrawer(lesson: widget.lesson, taskStatus: taskStatus)
          : null,
      body: widget.lesson.showRechner
          ? DefaultBody(
              controller: _controller,
              isLoading: isLoading,
              fadeAnimation: _fadeAnimation,
            )
          : Center(child: Text("Rechner is not available for this lesson")),
    );
  }
}
