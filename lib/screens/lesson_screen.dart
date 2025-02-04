import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/defaultappbar_widget.dart';

class GeoGebraTaskScreen extends StatefulWidget {
  const GeoGebraTaskScreen({super.key});

  @override
  State<GeoGebraTaskScreen> createState() => _GeoGebraTaskScreenState();
}

class _GeoGebraTaskScreenState extends State<GeoGebraTaskScreen> {
  late final WebViewController controller;
  static const String stateKey = "geogebra_state";

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.transparent)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (String url) async {
            await Future.delayed(Duration(seconds: 1));
            await restoreGeoGebraState();
          },
        ),
      )
      ..addJavaScriptChannel(
        'FlutterChannel',
        onMessageReceived: (JavaScriptMessage message) async {
          await saveGeoGebraState(message.message);
        },
      )
      ..loadRequest(Uri.parse(
          'file:///android_asset/flutter_assets/assets/html/geogebra_task.html'));
  }

  Future<void> saveGeoGebraState(String state) async {
    final prefs = await SharedPreferences.getInstance();

    if (state.isNotEmpty) {
      String encodedState = Uri.encodeComponent(state);
      await prefs.setString(stateKey, encodedState);
    }
  }

  Future<void> restoreGeoGebraState() async {
    final prefs = await SharedPreferences.getInstance();
    String? savedState = prefs.getString(stateKey);

    if (savedState != null && savedState.isNotEmpty) {
      String escapedState =
          savedState.replaceAll("'", "\\'").replaceAll("\n", "");

      controller.runJavaScript(
          "receiveFromFlutter(decodeURIComponent('$escapedState'));");
    }
  }

  void _checkUserTask() async {
    String result = await controller.runJavaScriptReturningResult("checkTask();") as String;
    print("User's Input: $result");

    if (result.contains("2, 2")) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Task completed! 🎉")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Try again! ❌")),
      );
    }
  }

  @override
  void dispose() {
    controller.runJavaScript("saveGeoGebraState();");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(
        title: "GeoGebra Task",
        showLeading: true,
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: _checkUserTask, // Check user input
          ),
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () async {
              controller.runJavaScript("saveGeoGebraState();");
            },
          ),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () async {
              controller.runJavaScript("receiveFromFlutter('RESET');");
              await saveGeoGebraState("");
            },
          ),
        ],
      ),
      body: WebViewWidget(controller: controller),
    );
  }
}
