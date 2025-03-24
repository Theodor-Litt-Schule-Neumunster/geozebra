import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DefaultBody extends StatelessWidget {
  final WebViewController controller;
  final bool isLoading;
  final Animation<double> fadeAnimation;

  const DefaultBody({
    super.key,
    required this.controller,
    required this.isLoading,
    required this.fadeAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        WebViewWidget(controller: controller),
        if (isLoading)
          FadeTransition(
            opacity: fadeAnimation,
            child: Container(
              color: Colors.white,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.calculate_rounded,
                        size: 80, color: Colors.blueAccent),
                    SizedBox(height: 20),
                    Text("Loading GeoGebra...",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 20),
                    CircularProgressIndicator(
                        strokeWidth: 3, color: Colors.blueAccent),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}