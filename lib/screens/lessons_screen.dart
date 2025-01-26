import 'package:flutter/material.dart';

// import '../widgets/bottombar_widget.dart';

class LessonsScreen extends StatefulWidget {
  const LessonsScreen({super.key});

  @override
  State<LessonsScreen> createState() => _LessonsScreenState();
}

class _LessonsScreenState extends State<LessonsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Geozebra"),
      ),

      // Temp content, wait until designed in Figma
      body: const Center(
        child: Text(
          'Aufgaben',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      
      // Should it be in the bottom bar? If yes -> uncomment & change currentIndex of profile_screen.dart to 2, also add a new case in widgets/bottombar_widget.dart
      // bottomNavigationBar: const BottomBarWidget(
      //   currentIndex: 1,
      // ),
    );
  }
}