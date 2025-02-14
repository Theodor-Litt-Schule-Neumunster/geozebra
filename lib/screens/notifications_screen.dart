import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
      ),
      body: ListView.builder(
        itemCount: 10, // Replace with actual notifications count
        itemBuilder: (context, index) {
          return ListTile(
            leading: const CircleAvatar(
              child: Icon(Icons.notifications),
            ),
            title: Text('Notification ${index + 1}'),
            subtitle: Text('This is a notification message #${index + 1}'),
            trailing: Text('${DateTime.now().hour}:${DateTime.now().minute}'),
            onTap: () {
              // Handle notification tap
              debugPrint('Tapped notification ${index + 1}');
            },
          );
        },
      ),
    );
  }
}