import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../models/class_model.dart';

class LessonScreen extends StatefulWidget {
  final Lesson lesson;
  const LessonScreen({super.key, required this.lesson});

  @override
  State<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen> {
  late final WebViewController controller;
  String nextTaskDescription = "Loading tasks...";

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..loadFlutterAsset('assets/html/rechner.html')
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (String url) {
            sendTasksToWebView();
          },
        ),
      );
  }

  void sendTasksToWebView() {
    List<Map<String, dynamic>> tasks = widget.lesson.tasks
        .map((task) => {
              "id": task.id,
              "description": task.description,
              "condition": task.condition,
            })
        .toList();

    controller.runJavaScript(
        """window.postMessage({ type: 'loadTasks', tasks: ${jsonEncode(tasks)} }, '*');""");

    updateNextTask();
  }

  void updateNextTask() async {
    for (var task in widget.lesson.tasks) {
      String result = await controller.runJavaScriptReturningResult("""
        (() => {
          try {
            let ggb = window.ggbApp.getAppletObject();
            return (${task.condition}) ? "completed" : "incomplete";
          } catch (e) { return "error"; }
        })();
      """) as String;

      if (result.contains("incomplete")) {
        setState(() {
          nextTaskDescription = task.description;
        });
        return;
      }
    }
    setState(() {
      nextTaskDescription = "All tasks completed!";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.lesson.lessonTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("Data saving not implemented"),
                    content: Text("Quit?"),
                    actions: [
                      TextButton(
                        child: Text("No"),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      TextButton(
                        child: Text("Yes"),
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
        automaticallyImplyLeading: false,
      ),
      endDrawer: Drawer(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: widget.lesson.tasks.map(
                      (task) => ExpansionTile(
                        leading: Icon(Icons.radio_button_unchecked_outlined, color: Theme.of(context).colorScheme.onPrimary),
                        title: Text(task.shortDescription, style: TextStyle(fontSize: 16)),
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(task.description),
                          ),
                          TextButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text("Lösungshinweise"),
                                    content: Text("No hints available."),
                                    actions: [
                                      TextButton(
                                        child: Text("Close", style: TextStyle(color: Theme.of(context).colorScheme.onPrimary)),
                                        onPressed: () => Navigator.of(context).pop(),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: Text("Lösungshinweise", style: TextStyle(color: Theme.of(context).colorScheme.onPrimary)),
                          ),
                        ],
                      ),
                    ).toList(),
              ),
            ),
          ],
        ),
      ),
      
      body: Stack(
        children: [
          WebViewWidget(controller: controller),
          Positioned(
            top: 10,
            right: 10,
            child: Container(
              alignment: Alignment.centerRight,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                nextTaskDescription,
                textAlign: TextAlign.right,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
