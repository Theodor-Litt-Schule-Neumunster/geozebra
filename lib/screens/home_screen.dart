import 'package:flutter/material.dart';
import 'package:local_notifications/local_notifications.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Center(
        child: ElevatedButton(onPressed: NotificationsProvider(), child: child) // FIXME
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text('Welcome to GeoZebra!'),
            Text('This is the home screen.'),
          ],
        ),
      ),
    );
  }
}