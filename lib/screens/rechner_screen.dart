import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:async';
import 'package:geozebra_app/services/lessons_service.dart';
import 'package:provider/provider.dart';
import 'package:geozebra_app/providers/progress_provider.dart';

class RechnerScreen extends StatefulWidget {
  const RechnerScreen({super.key});

  @override
  State<RechnerScreen> createState() => _RechnerScreenState();
}

class _RechnerScreenState extends State<RechnerScreen>
    with SingleTickerProviderStateMixin {
  late final WebViewController _controller;
  bool isLoading = true;
  bool minLoadingTimePassed = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  final LessonService _lessonService = LessonService();
  Timer? _stateTrackingTimer;

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
          onPageFinished: (url) async {
            // Start fade-out animation if both conditions are met
            if (minLoadingTimePassed) {
              _animationController.forward().then((_) {
                if (mounted) {
                  setState(() {
                    isLoading = false;
                  });
                }
              });
              await _loadCalculatorState();
              _startStateTracking();
            } else {
              Timer(Duration(milliseconds: 500), () async {
                if (mounted) {
                  _animationController.forward().then((_) {
                    if (mounted) {
                      setState(() {
                        isLoading = false;
                      });
                    }
                  });
                  await _loadCalculatorState();
                  _startStateTracking();
                }
              });
            }
          },
        ),
      )
      ..addJavaScriptChannel(
        "calculatorState",
        onMessageReceived: (message) {
          _saveCalculatorState(message.message);
        },
      )
      ..loadFlutterAsset("assets/html/rechner.html");
  }

  Future<void> _loadCalculatorState() async {
    try {
      final state = await _lessonService.getCalculatorState();
      if (state != null) {
        _controller.runJavaScript("loadCalculatorState('$state');");
        print("Loaded calculator state");
      }
    } catch (e) {
      print('Error loading calculator state: $e');
    }
  }

  Future<void> _saveCalculatorState(String base64State) async {
    try {
      // Save using both service and provider
      await _lessonService.saveCalculatorState(base64State);
      
      // Use provider to update state throughout app
      final progressProvider = Provider.of<ProgressProvider>(context, listen: false);
      await progressProvider.saveCalculatorState(base64State);
      
      print("Saved calculator state");
    } catch (e) {
      print('Error saving calculator state: $e');
    }
  }

  void _startStateTracking() {
    // Cancel existing timer if any
    _stateTrackingTimer?.cancel();
    
    // Periodically save calculator state
    _stateTrackingTimer = Timer.periodic(Duration(seconds: 5), (timer) {
      if (mounted) {
        _controller.runJavaScript("sendCalculatorStateToFlutter();");
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _stateTrackingTimer?.cancel();
    _animationController.dispose();
    
    // Save state one last time before disposing
    if (mounted) {
      _controller.runJavaScript("sendCalculatorStateToFlutter();");
    }
    
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("GeoGebra")),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),

          if (isLoading)
            FadeTransition(
              opacity: _fadeAnimation,
              child: Container(
                color: Colors.white,
                child: Center(
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
            ),
        ],
      ),
    );
  }
}
