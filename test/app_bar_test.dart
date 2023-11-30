import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:course_compass/view/components/app_bar.dart';

void main() {
  group('CustomAppBar', () {
    testWidgets('Should open navigation menu when leading button is pressed',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            appBar: CustomAppBar(),
            drawer: NavigationDrawer(
              children: [Text("Drawer")],
            ),
          ),
        ),
      );

      // Tap on the leading button
      await tester.tap(find.byTooltip('Open navigation menu'));
      await tester.pumpAndSettle();

      // Verify that the navigation menu is opened
      expect(find.byType(NavigationDrawer), findsOneWidget);
    });

    testWidgets('Should navigate to home page when home button is pressed',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          routes: {
            '/home': (context) => const Scaffold(key: Key('/home')),
          },
          home: const Scaffold(
            appBar: CustomAppBar(),
          ),
        ),
      );

      // Tap on the home button
      await tester.tap(find.byTooltip('Go to home page'));
      await tester.pumpAndSettle();

      // Verify that the home page is navigated to
      expect(find.byKey(const Key('/home')), findsOneWidget);
    });

    testWidgets(
        'Should navigate to profile page when profile button is pressed',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          routes: {
            '/profile': (context) => const Scaffold(key: Key('/profile')),
          },
          home: const Scaffold(
            appBar: CustomAppBar(),
          ),
        ),
      );

      // Tap on the profile button
      await tester.tap(find.byTooltip('Go to profile page'));
      await tester.pumpAndSettle();

      // Verify that the profile page is navigated to
      expect(find.byKey(const Key('/profile')), findsOneWidget);
    });
  });
}
