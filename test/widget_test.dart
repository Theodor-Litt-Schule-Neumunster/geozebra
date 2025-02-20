import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:geozebra_app/widgets/defaultappbar_widget.dart';
import 'package:geozebra_app/widgets/courses_widget.dart';
import 'package:geozebra_app/widgets/course_continue_widget.dart';
import 'package:geozebra_app/widgets/bottombar_widget.dart';
import 'package:geozebra_app/screens/settings_screen.dart';
import 'package:geozebra_app/screens/search_screen.dart';
import 'package:geozebra_app/screens/profile_screen.dart';
import 'package:geozebra_app/screens/notification_screen.dart';
import 'package:geozebra_app/screens/lesson_screen.dart';
import 'package:geozebra_app/screens/home_screen.dart';
import 'package:geozebra_app/models/class_model.dart';

void main() {
  testWidgets('DefaultAppBar widget test', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: Scaffold(appBar: DefaultAppBar(title: 'Test AppBar'))));
    expect(find.text('Test AppBar'), findsOneWidget);
  });

  testWidgets('CoursesWidget widget test', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: Scaffold(body: CoursesWidget(courses: ['Course 1', 'Course 2']))));
    expect(find.text('Course 1'), findsOneWidget);
    expect(find.text('Course 2'), findsOneWidget);
  });

  testWidgets('CourseContinueWidget widget test', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: Scaffold(body: CourseContinueWidget(courses: ['Course 1', 'Course 2']))));
    expect(find.text('Course 1'), findsOneWidget);
    expect(find.text('Course 2'), findsOneWidget);
  });

  testWidgets('BottomBarWidget widget test', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: Scaffold(bottomNavigationBar: BottomBarWidget(currentIndex: 0))));
    expect(find.byIcon(Icons.home), findsOneWidget);
    expect(find.byIcon(Icons.person), findsOneWidget);
  });

  testWidgets('SettingsScreen widget test', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: SettingsScreen()));
    expect(find.text('Einstellungen'), findsOneWidget);
  });

  testWidgets('SearchScreen widget test', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: SearchScreen()));
    expect(find.text('Suchen'), findsOneWidget);
  });

  testWidgets('ProfileScreen widget test', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: ProfileScreen()));
    expect(find.text('Übersicht'), findsOneWidget);
  });

  testWidgets('NotificationScreen widget test', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: NotificationScreen()));
    expect(find.text('Benachrichtigungen'), findsOneWidget);
  });

  testWidgets('LessonScreen widget test', (WidgetTester tester) async {
    final lesson = Lesson(
      lessonId: '1',
      lessonTitle: 'Test Lesson',
      description: 'Description',
      shortDescription: 'Short Description',
      tasks: [],
    );
    await tester.pumpWidget(MaterialApp(home: LessonScreen(lesson: lesson)));
    expect(find.text('Test Lesson'), findsOneWidget);
  });

  testWidgets('HomeScreen widget test', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: HomeScreen()));
    expect(find.text('Moin!'), findsOneWidget);
  });

}