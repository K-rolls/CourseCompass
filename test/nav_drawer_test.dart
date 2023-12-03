import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:course_compass/view/components/nav_drawer.dart';

void main() {
  group('NavDrawer', () {
    testWidgets('Should display the correct number of navigation options',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: NavDrawer(),
          ),
        ),
      );

      // Verify that the correct number of navigation options are displayed
      expect(find.byType(NavigationDrawerDestination), findsNWidgets(9));
    });

    testWidgets('Should navigate from /home to /grades', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          routes: {
            '/home': (context) => const Scaffold(key: Key('/home')),
            '/grades': (context) => const Scaffold(key: Key('/grades')),
            '/profile': (context) => const Scaffold(key: Key('/profile')),
            '/course_archive': (context) =>
                const Scaffold(key: Key('/course_archive')),
          },
          home: const Scaffold(
            body: NavDrawer(),
          ),
        ),
      );

      // Tap on the "Grades" option
      await tester.tap(find.text('Grades'));
      await tester.pumpAndSettle();

      // Verify that the correct page is navigated to
      expect(find.byKey(const Key('/grades')), findsOneWidget);
    });

    testWidgets('Should navigate from /home to /profile', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          routes: {
            '/home': (context) => const Scaffold(key: Key('/home')),
            '/grades': (context) => const Scaffold(key: Key('/grades')),
            '/profile': (context) => const Scaffold(key: Key('/profile')),
            '/course_archive': (context) =>
                const Scaffold(key: Key('/course_archive')),
          },
          home: const Scaffold(
            body: NavDrawer(),
          ),
        ),
      );

      // Tap on the "Profile" option
      await tester.tap(find.text('Profile'));
      await tester.pumpAndSettle();

      // Verify that the correct page is navigated to
      expect(find.byKey(const Key('/profile')), findsOneWidget);
    });
  });
}
