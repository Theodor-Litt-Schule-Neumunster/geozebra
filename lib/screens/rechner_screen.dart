import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:async';

class RechnerScreen extends StatefulWidget {
  const RechnerScreen({super.key});

  @override
  State<RechnerScreen> createState() => _RechnerScreenState();
}

class _RechnerScreenState extends State<RechnerScreen>
    with SingleTickerProviderStateMixin {
  late final WebViewController _controller;
  bool isLoading = true; // Track loading state
  bool minLoadingTimePassed = false; // Track minimum loading duration
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Set up fade animation for loading screen
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 600), // Smooth fade-out
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );

    // Ensure loading screen is visible for at least 2 seconds
    Timer(Duration(seconds: 2), () {
      setState(() {
        minLoadingTimePassed = true;
      });
    });

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (url) {
            // Start fade-out animation if both conditions are met
            if (minLoadingTimePassed) {
              _animationController.forward().then((_) {
                setState(() {
                  isLoading = false;
                });
              });
            } else {
              Timer(Duration(milliseconds: 500), () {
                _animationController.forward().then((_) {
                  setState(() {
                    isLoading = false;
                  });
                });
              });
            }
          },
        ),
      )
      ..loadFlutterAsset("assets/html/rechner.html");
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("GeoGebra")),
      body: Stack(
        children: [
          // WebView (Hidden when loading)
          WebViewWidget(controller: _controller),

          // Loading Screen with Fade-Out Animation
          if (isLoading)
            FadeTransition(
              opacity: _fadeAnimation,
              child: Container(
                color: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TweenAnimationBuilder<double>(
                      duration: Duration(seconds: 1),
                      tween: Tween(begin: 0, end: 1),
                      builder: (context, value, child) {
                        return Transform.scale(
                          scale: value,
                          child: child,
                        );
                      },
                      child: Icon(Icons.calculate_rounded,
                          size: 80, color: Colors.blueAccent),
                    ),

                    SizedBox(height: 20),

                    TweenAnimationBuilder<int>(
                      duration: Duration(seconds: 3),
                      tween: IntTween(begin: 0, end: 3),
                      builder: (context, value, child) {
                        String dots = "." * (value % 4);
                        return Text(
                          "Loading GeoGebra$dots",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        );
                      },
                      onEnd: () => setState(() {}),
                    ),

                    SizedBox(height: 20),

                    // Subtle Progress Indicator
                    SizedBox(
                      width: 50,
                      height: 50,
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        color: Colors.blueAccent,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
