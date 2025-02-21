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
  testWidgets('DefaultAppBar Widget Test', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: Scaffold(appBar: DefaultAppBar(title: 'Test AppBar'))));
    expect(find.text('Test AppBar'), findsOneWidget);
  });

  testWidgets('Kursübersicht Widget Test', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: Scaffold(body: CoursesWidget(courses: ['Kurs 1', 'Kurs 2']))));
    expect(find.text('Kurs 1'), findsOneWidget);
    expect(find.text('Kurs 2'), findsOneWidget);
  });

  testWidgets('Kurs fortsetzen Widget Test', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: Scaffold(body: CourseContinueWidget(courses: ['Kurs 1', 'Kurs 2']))));
    expect(find.text('Kurs 1'), findsOneWidget);
    expect(find.text('Kurs 2'), findsOneWidget);
  });

  testWidgets('Navigationsleiste Widget Test', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: Scaffold(bottomNavigationBar: BottomBarWidget(currentIndex: 0))));
    expect(find.byIcon(Icons.home), findsOneWidget);
    expect(find.byIcon(Icons.person), findsOneWidget);
  });

  testWidgets('Einstellungen Bildschirm Test', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: SettingsScreen()));
    expect(find.text('Einstellungen'), findsOneWidget);
  });

  testWidgets('Suche Bildschirm Test', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: SearchScreen()));
    expect(find.text('Suchen'), findsOneWidget);
  });

  testWidgets('Profil Bildschirm Test', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: ProfileScreen()));
    expect(find.text('Übersicht'), findsOneWidget);
  });

  testWidgets('Benachrichtigungen Bildschirm Test', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: NotificationScreen()));
    expect(find.text('Benachrichtigungen'), findsOneWidget);
  });

  testWidgets('Lektion Bildschirm Test', (WidgetTester tester) async {
    final lesson = Lesson(
      lessonId: '1',
      lessonTitle: 'Test Lektion',
      description: 'Beschreibung',
      shortDescription: 'Kurzbeschreibung',
      tasks: [],
    );
    await tester.pumpWidget(MaterialApp(home: LessonScreen(lesson: lesson)));
    expect(find.text('Test Lektion'), findsOneWidget);
  });

  testWidgets('Startseite Bildschirm Test', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: HomeScreen()));
    expect(find.text('Moin!'), findsOneWidget);
  });

}