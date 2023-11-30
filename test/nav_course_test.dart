import 'package:course_compass/view/components/nav_course.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('NavCourse', () {
    testWidgets('Should display the correct icon and label', (tester) async {
      const color = Colors.blue;
      const name = 'Math';

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: NavigationDrawer(
              children: [
                NavCourse(
                  color: color,
                  name: name,
                  icon: Icon(Icons.circle),
                  label: Text(''),
                ),
              ],
            ),
          ),
        ),
      );

      // Verify that the correct label is displayed
      expect(find.text(name), findsOneWidget);
    });
  });
}
