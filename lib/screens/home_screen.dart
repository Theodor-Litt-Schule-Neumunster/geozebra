import 'package:flutter/material.dart';
import 'package:geozebra_app/providers/notifications_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            NotificationsProvider().showNotification(
              title: "Test Notification",
              body: "This is a test notification.",
            );
          },
          child: Text("Show Notification"),
        ),
      ),
    );
  }
}