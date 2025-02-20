import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:webview_flutter/webview_flutter.dart';
import '../models/class_model.dart';
import '../widgets/defaultappbar_widget.dart';
import '../services/lessons_service.dart';

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
  Map<String, bool> overriddenTasks = {};
  Timer? _taskCheckTimer;

  @override
  void initState() {
    super.initState();
    _loadTaskData(); // Load task & GeoGebra data

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
          onPageFinished: (url) async {
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
              _restoreGeoGebraState();  // Restore previous GeoGebra state
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
      ..addJavaScriptChannel(
        "saveGeoGebraState",
        onMessageReceived: (message) {
          LessonService.saveGeoGebraState(message.message);
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

  Future<void> _loadTaskData() async {
    taskStatus = await LessonService.loadTaskStatus();
    overriddenTasks = await LessonService.loadOverriddenTasks();
    setState(() {}); 
    print("📂 Loaded task data: $taskStatus");
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
      final Map<String, dynamic> status = jsonDecode(jsonStatus);
      setState(() {
        status.forEach((taskId, completed) {
          if (!overriddenTasks.containsKey(taskId)) {
            taskStatus[taskId] = completed;
          }
        });
      });

      LessonService.saveTaskData(taskStatus, overriddenTasks);
    } catch (e) {
      print("❌ Error parsing task status: $e");
    }
  }

  void _restoreGeoGebraState() async {
    final savedState = await LessonService.loadGeoGebraState();
    if (savedState != null) {
      _controller.runJavaScript("restoreGeoGebraState('$savedState');");
    }
  }

  void _manuallyCompleteTask(String taskId) {
    setState(() {
      overriddenTasks[taskId] = true;
      taskStatus[taskId] = true;
    });

    LessonService.saveTaskData(taskStatus, overriddenTasks);
  }

  void _showCompleteTaskDialog(String taskId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Complete Task?"),
        content: Text("Do you want to manually mark this task as complete?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("No"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _manuallyCompleteTask(taskId);
            },
            child: Text("Yes"),
          ),
        ],
      ),
    );
  }
}
