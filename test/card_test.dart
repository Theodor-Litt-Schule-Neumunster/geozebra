import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geozebra_app/cards/home_card.dart';
import 'package:geozebra_app/cards/search_card.dart';

void main() {
  testWidgets('ScreenCard displays correct icon, title, and subtitle', (WidgetTester tester) async {
    const testIcon = Icons.home;
    const testTitle = 'Test Title';
    const testSubtitle = 'Test Subtitle';
    bool onTapCalled = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ScreenCard(
            iconData: testIcon,
            title: testTitle,
            subtitle: testSubtitle,
            onTap: () {
              onTapCalled = true;
            },
          ),
        ),
      ),
    );

    expect(find.byIcon(testIcon), findsOneWidget);
    expect(find.text(testTitle), findsOneWidget);
    expect(find.text(testSubtitle), findsOneWidget);
  });

  testWidgets('ScreenCard onTap callback is triggered', (WidgetTester tester) async {
    bool onTapCalled = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ScreenCard(
            iconData: Icons.home,
            title: 'Test Title',
            subtitle: 'Test Subtitle',
            onTap: () {
              onTapCalled = true;
            },
          ),
        ),
      ),
    );

    await tester.tap(find.byType(ListTile));
    expect(onTapCalled, isTrue);
  });

  testWidgets('SearchCard renders correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SearchCard(),
        ),
      ),
    );

    expect(find.byType(SearchCard), findsOneWidget);
  });
}