import 'package:flutter/material.dart';

import "../widgets/defaultappbar_widget.dart";

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const DefaultAppBar(
        title: "Benachrichtigungen",
        showLeading: true,
      ),
    );
  }
}