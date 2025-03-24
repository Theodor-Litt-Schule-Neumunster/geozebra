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
import 'package:geozebra_app/services/lessons_service.dart';

class LessonScreen extends StatefulWidget {
  final Lesson lesson;
  final String classId;
  const LessonScreen({super.key, required this.lesson, required this.classId});

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
  final LessonService _lessonService = LessonService();
  int _completionPercent = 0;

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

    _loadSavedProgress();

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
              _loadCalculatorState();
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
                  _loadCalculatorState();
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
      ..addJavaScriptChannel(
        "calculatorState",
        onMessageReceived: (message) {
          _saveCalculatorState(message.message);
        },
      )
      ..loadFlutterAsset("assets/html/rechner.html");
  }

  Future<void> _loadSavedProgress() async {
    try {
      final progress = await _lessonService.getLessonProgress(widget.lesson.lessonId);
      if (progress != null) {
        setState(() {
          _completionPercent = progress['completionPercent'] as int;
        });
      }

      final taskProgress = await _lessonService.getTasksProgressForLesson(widget.lesson.lessonId);
      
      if (taskProgress.isNotEmpty) {
        setState(() {
          for (var task in taskProgress) {
            taskStatus[task['taskId'] as String] = task['isCompleted'] == 1;
          }
        });
      }
    } catch (e) {
      print('Error loading lesson progress: $e');
    }
  }

  Future<void> _loadCalculatorState() async {
    try {
      final state = await _lessonService.getCalculatorState();
      if (state != null && state.isNotEmpty) {
        _controller.runJavaScript("loadCalculatorState('$state');");
        print("Loaded calculator state in lesson");
      }
    } catch (e) {
      print('Error loading calculator state: $e');
    }
  }

  Future<void> _saveCalculatorState(String base64State) async {
    if (base64State.isEmpty) return;
    
    try {
      await _lessonService.saveCalculatorState(base64State);
      print("Saved calculator state from lesson");
    } catch (e) {
      print('Error saving calculator state: $e');
    }
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
      
      if (timer.tick % 5 == 0) {
        _controller.runJavaScript("sendCalculatorStateToFlutter();");
      }
    });
  }

  Future<void> _updateTaskStatus(String jsonStatus) async {
    try {
      final Map<String, dynamic> status = jsonDecode(jsonStatus);
      
      setState(() {
        taskStatus.clear();
        taskStatus.addAll(status.map((key, value) => MapEntry(key, value == true)));
      });

      final completionPercent = await _lessonService.calculateLessonCompletionPercent(
        widget.lesson.lessonId, 
        taskStatus
      );
      
      setState(() {
        _completionPercent = completionPercent;
      });

      await _lessonService.saveLessonProgress(
        widget.lesson.lessonId,
        widget.classId,
        completionPercent == 100,
        completionPercent
      );

      for (var entry in taskStatus.entries) {
        await _lessonService.saveTaskProgress(
          entry.key,
          widget.lesson.lessonId,
          entry.value
        );
      }
    } catch (e) {
      print("Error parsing task status: $e");
    }
  }

  void _scrollToSection(int index) {
    final key = _sectionKeys[index];
    Scrollable.ensureVisible(
      key.currentContext!,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: DefaultAppBar(
          title: widget.lesson.lessonTitle,
          subtitle: _completionPercent > 0 ? 'Fortschritt: $_completionPercent%' : null,
        ),
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
      ),
    );
  }
}
