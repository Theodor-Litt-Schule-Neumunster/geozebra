import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  List<Map<String, dynamic>> notifications = [
    {
      'title': 'Willkommen!',
      'body': 'Danke, dass du unsere App nutzt.',
      'read': false
    },
    {
      'title': 'Update verfügbar',
      'body': 'Version 1.2 ist jetzt verfügbar.',
      'read': false
    },
  ];

  bool notificationsEnabled = true;

  @override
  void initState() {
    super.initState();
    loadSettings();
    initNotifications();
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted && notificationsEnabled) {
        showSnackbar("Tippe auf eine Nachricht, um mehr zu erfahren.");
      }
    });
  }

  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      notificationsEnabled = prefs.getBool('notificationsEnabled') ?? true;
    });
  }

  Future<void> toggleNotifications(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notificationsEnabled', value);
    setState(() {
      notificationsEnabled = value;
    });
  }

  Future<void> initNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> showNotification(String title, String body) async {
    if (!notificationsEnabled) return;

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'channel_id',
      'channel_name',
      importance: Importance.high,
      priority: Priority.high,
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
    );
  }

  void showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: GoogleFonts.roboto(fontSize: 16)),
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void markAsRead(int index) {
    setState(() {
      notifications[index]['read'] = true;
    });
  }

  void deleteNotification(int index) {
    setState(() {
      notifications.removeAt(index);
    });
  }

  void addNotification(String title, String body) {
    setState(() {
      notifications.insert(0, {'title': title, 'body': body, 'read': false});
    });
    showNotification(title, body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Benachrichtigungen"),
        actions: [
          Switch(
            value: notificationsEnabled,
            onChanged: toggleNotifications,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView.builder(
          itemCount: notifications.length,
          itemBuilder: (context, index) {
            final notification = notifications[index];
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                leading: CircleAvatar(
                  backgroundColor:
                      notification['read'] ? Colors.grey : Colors.blue,
                  child: Icon(
                    notification['read']
                        ? Icons.check_circle_outline
                        : Icons.notifications_active,
                    color: Colors.white,
                  ),
                ),
                title: Text(
                  notification['title'],
                  style: GoogleFonts.roboto(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: notification['read'] ? Colors.grey : Colors.black,
                  ),
                ),
                subtitle: Text(
                  notification['body'],
                  style: GoogleFonts.roboto(fontSize: 16),
                ),
                onTap: () {
                  markAsRead(index);
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      title: Text(notification['title']),
                      content: Text(notification['body']),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addNotification(
              "Neu!", "Hier ist eine neue Benachrichtigung für dich.");
        },
        child: const Icon(Icons.notifications),
      ),
    );
  }
}
