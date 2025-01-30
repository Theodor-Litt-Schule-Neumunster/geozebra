import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../widgets/defaultappbar_widget.dart';

class RechnerScreen extends StatefulWidget {
  const RechnerScreen({super.key});

  @override
  State<RechnerScreen> createState() => _RechnerScreen();
}

class _RechnerScreen extends State<RechnerScreen> {
  late final WebViewController controller;
  static const String stateKey = "geogebra_state";

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (String url) async {
            debugPrint("Page finished loading: $url");
            await restoreGeoGebraState(); // Load saved state when page loads
          },
        ),
      )
      ..addJavaScriptChannel(
        'FlutterChannel',
        onMessageReceived: (JavaScriptMessage message) async {
          debugPrint("Received message from JavaScript: ${message.message}");
          await saveGeoGebraState(message.message);
        },
      )
      ..loadRequest(Uri.parse('file:///android_asset/flutter_assets/assets/html/rechner.html'));
  }

  Future<void> saveGeoGebraState(String state) async {
    final prefs = await SharedPreferences.getInstance();
    debugPrint("Saving GeoGebra state: $state");
    await prefs.setString(stateKey, state);
  }

  Future<void> restoreGeoGebraState() async {
    final prefs = await SharedPreferences.getInstance();
    String? savedState = prefs.getString(stateKey);
    debugPrint("Restoring GeoGebra state: $savedState");

    if (savedState != null && savedState.isNotEmpty) {
      controller.runJavaScript("receiveFromFlutter('$savedState');");
    }
  }

  Future<void> _handleBackPress() async {
    debugPrint("Back button pressed, saving state...");
    controller.runJavaScript("saveGeoGebraState();");
    await Future.delayed(Duration(milliseconds: 500)); // Allow time for JavaScript execution
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        debugPrint("WillPopScope triggered");
        await _handleBackPress();
        return false;
      },
      child: Scaffold(
        appBar: DefaultAppBar(
          title: "Rechner",
          showLeading: true,
          actions: [
            IconButton(
              icon: Icon(Icons.save),
              onPressed: () async {
                debugPrint("Save button pressed");
                controller.runJavaScript("saveGeoGebraState();");
              },
            ),
          ],
        ),
        body: WebViewWidget(controller: controller),
      ),
    );
  }
}