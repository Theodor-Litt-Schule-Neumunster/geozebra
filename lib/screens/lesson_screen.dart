import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:geozebra_app/models/class_model.dart';
import 'package:geozebra_app/widgets/defaultappbar_widget.dart';
import 'package:geozebra_app/widgets/lessonScreen/defaultBody.dart';
import 'package:geozebra_app/widgets/lessonScreen/defaultDrawer.dart';
import 'package:geozebra_app/widgets/lessonScreen/textDrawer.dart';
import 'package:geozebra_app/widgets/lessonScreen/textBody.dart';

class LessonScreen extends StatefulWidget {
  final Lesson lesson;
  const LessonScreen({super.key, required this.lesson});

  @override
  State<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen> with SingleTickerProviderStateMixin {
  late final WebViewController _controller;
  bool isLoading = true;
  bool minLoadingTimePassed = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  Map<String, bool> taskStatus = {};
  Timer? _taskCheckTimer;

  late ScrollController _scrollController;
  final List<GlobalKey> _sectionKeys = [];

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

    _scrollController = ScrollController();
    _sectionKeys.addAll(
      widget.lesson.textSections.map((_) => GlobalKey()).toList()
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
      final Map<String, dynamic> status = jsonDecode(jsonStatus);

      setState(() {
        taskStatus.clear();
        taskStatus
            .addAll(status.map((key, value) => MapEntry(key, value == true)));
      });

    } catch (e) {
      print("Error parsing task status: $e");
    }
  }

  void _scrollToSection(int index) {
    final key = _sectionKeys[index];
    // Use Scrollable.ensureVisible() to jump to that GlobalKey
    Scrollable.ensureVisible(
      key.currentContext!,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(title: widget.lesson.lessonTitle),
      endDrawer: widget.lesson.showRechner
          ? DefaultDrawer(lesson: widget.lesson, taskStatus: taskStatus)
          : TextDrawer(
              textSections: widget.lesson.textSections,
              onTextSectionSelected: _scrollToSection,
            ),
      body: widget.lesson.showRechner
          ? DefaultBody(
              controller: _controller,
              isLoading: isLoading,
              fadeAnimation: _fadeAnimation,
            )
          : TextBody(
              textSections: widget.lesson.textSections,
              scrollController: _scrollController,
              sectionKeys: _sectionKeys,
            ),
    );
  }
}
