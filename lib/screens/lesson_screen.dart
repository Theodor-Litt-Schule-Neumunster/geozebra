import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import '../models/class_model.dart';

class LessonScreen extends StatefulWidget {
  final Lesson lesson;
  const LessonScreen({Key? key, required this.lesson}) : super(key: key);

  @override
  State<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen> {
  InAppWebViewController? webViewController;
  Map<String, bool> taskStatus = {};
  Timer? _taskCheckTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startTaskCheckLoop();
    });
  }

  @override
  void dispose() {
    _taskCheckTimer?.cancel();
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

    webViewController?.evaluateJavascript(
        source: "receiveTasksFromFlutter('$tasksJson');");
  }

  void _startTaskCheckLoop() {
    _taskCheckTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      _checkTaskCompletion();
    });
  }

  Future<void> _checkTaskCompletion() async {
    if (webViewController == null) return;

    final result = await webViewController?.evaluateJavascript(source: """
      (function() {
          if (typeof getTaskStatus === "function") {
              return JSON.stringify(getTaskStatus());
          }
          return "{}";
      })();
  """);

    if (result != null && result is String && result.isNotEmpty) {
      try {
        final Map<String, dynamic> status = jsonDecode(result);
        setState(() {
          taskStatus = status.map((key, value) => MapEntry(key, value == true));
        });
      } catch (e) {
        // Handle error
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.lesson.lessonTitle)),
      endDrawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              child: Text("Aufgaben", style: TextStyle(fontSize: 22)),
            ),
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
      body: Column(
        children: [
          Expanded(
            child: InAppWebView(
              initialFile: "assets/html/rechner_beta.html",
              initialOptions: InAppWebViewGroupOptions(
                crossPlatform: InAppWebViewOptions(javaScriptEnabled: true),
              ),
              onWebViewCreated: (controller) {
                webViewController = controller;
                Future.delayed(Duration(seconds: 2), () {
                  sendAllTasksToWebView();
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}