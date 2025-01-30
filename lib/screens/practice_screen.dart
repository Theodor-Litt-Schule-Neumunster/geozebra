import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../widgets/defaultappbar_widget.dart';

class PracticeScreen extends StatefulWidget {
  const PracticeScreen({super.key});

  @override
  State<PracticeScreen> createState() => _PracticeScreen();
}

class _PracticeScreen extends State<PracticeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(
        title: "Üben",
        showLeading: true,
      ),

      // body: WebView(
      //   initialUrl: 'https://www.google.com',
      //   javascriptMode: JavascriptMode.unrestricted,
      // ),
    );
  }
}