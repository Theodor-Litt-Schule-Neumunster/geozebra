import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:webview_flutter/webview_flutter.dart';
import '../models/class_model.dart';
import '../widgets/defaultappbar_widget.dart';

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
                _animationController.forward().then((_) {
                  if (mounted) {
                    setState(() {
                      isLoading = false;
                    });
                  }
                });
                sendAllTasksToWebView();
                _startTaskCheckLoop();
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
      ..loadFlutterAsset("assets/html/rechner_beta.html");
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
      endDrawer: Builder(
        builder: (context) => Drawer(
          child: ListView(
            children: [
              DrawerHeader(
                  child: Text("Aufgaben", style: TextStyle(fontSize: 22))),
              ...widget.lesson.tasks.map((task) {
                return ListTile(
                  title: Text(task.shortDescription),
                  subtitle: Text(
                    taskStatus[task.id] == true
                        ? "✅ Aufgabe abgeschlossen!"
                        : "⏳ Aufgabe wird geprüft...",
                    style: TextStyle(
                        color: taskStatus[task.id] == true
                            ? Colors.green
                            : Colors.red),
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (isLoading)
            FadeTransition(
              opacity: _fadeAnimation,
              child: Container(
                color: Colors.white,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.calculate_rounded,
                          size: 80, color: Colors.blueAccent),
                      SizedBox(height: 20),
                      Text("Loading GeoGebra...",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(height: 20),
                      CircularProgressIndicator(
                          strokeWidth: 3, color: Colors.blueAccent),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
