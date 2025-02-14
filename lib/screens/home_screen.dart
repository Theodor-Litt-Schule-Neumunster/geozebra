import 'package:flutter/material.dart';
import '../widgets/course_continue_widget.dart';
import '../widgets/courses_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme =
        Theme.of(context).brightness == Brightness.dark ? 'Dark' : 'Light';

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70.0, // Set the height of the AppBar
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Moin',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Text(
              'Active Theme: $theme',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Define the action for the search button here
            },
          ),
        ],
        backgroundColor: Color.fromRGBO(24, 24, 24, 1),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CoursesWidget(
              courses: ['Course 1', 'Course 2', 'Course 3', 'Course 4', 'Course 5', 'Course 6', 'Course 7'],
            ),
            Container(
              color: Colors.green, // Color for the second container
              child: Column(
                children: [
                  CourseContinueWidget(
                    courses: ['Course 1', 'Course 2', 'Course 3', 'Course 4', 'Course 5', 'Course 6', 'Course 7'],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Color.fromRGBO(24, 24, 24, 1),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(Icons.home, color: Colors.white),
                onPressed: () {
                  // Define the action for the home button here
                },
              ),
              IconButton(
                icon: Icon(Icons.settings, color: Colors.white),
                onPressed: () {
                  // Define the action for the settings button here
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
