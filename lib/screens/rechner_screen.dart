import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../widgets/defaultappbar_widget.dart';

class RechnerScreen extends StatefulWidget {
  const RechnerScreen({super.key});

  @override
  State<RechnerScreen> createState() => _RechnerScreen();
}

class _RechnerScreen extends State<RechnerScreen> {
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.transparent)

      ..loadRequest(Uri.parse(
          'file:///android_asset/flutter_assets/assets/html/geogebra_task.html'));
          // 'https://www.google.com/search?q=calculator'));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(
        title: "Rechner",
        showLeading: true,
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
            },
          ),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: (){
            },
          ),
        ],
      ),
      body: WebViewWidget(controller: controller),
    );
  }
}
