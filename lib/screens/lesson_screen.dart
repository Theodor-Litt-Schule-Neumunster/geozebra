import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../models/class_model.dart';
// import "../widgets/defaultappbar_widget.dart";

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
              "condition": task.condition
            })
        .toList();

    controller.runJavaScript("""
      window.postMessage({ type: 'loadTasks', tasks: ${jsonEncode(tasks)} }, '*');
    """);

    updateNextTask();
  }

  // FIXME: For some f´in reason, this shi* is NOT working correctly
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
                    // TODO: Implement data saving
                    // FIXME: Change button color depending on theme, currently only white
                    title: Text("Data saving not implemented"),
                    content: Text("Quit?"),
                    actions: [
                      TextButton(
                        child: Text("No"),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton(
                        child: Text("Yes"),
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.of(context)
                              .pop();
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
                children: widget.lesson.tasks
                    .map((task) => ListTile(title: Text(task.description)))
                    .toList(),
              ),
            ),
          ],
        ),
      ),


      // TODO: Implement theme switching for GeoGebra
      body: Stack(
        children: [
          WebViewWidget(controller: controller),
          Positioned(
            top: 2,
            right: 2,
            child: Container(
              alignment: Alignment.centerRight,
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color.fromARGB(141, 0, 0, 0),
                borderRadius: BorderRadius.circular(2),
              ),
              child: Text(
                nextTaskDescription,
                textAlign: TextAlign.right,
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
