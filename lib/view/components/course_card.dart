import 'dart:async';

import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../controller/course_controller.dart';
import '../../model/course.dart';
import '../styles/text_style.dart';
import '../course_view.dart';

class CourseCard extends StatelessWidget {
  final String name;
  final Color color;
  final Future<Null> Function() onLongPress;
  final CourseController _courseController = CourseController();

  /// Creates a card that displays a course that the user has added.
  ///
  /// The `name` parameter is a string representing the name of the course.
  /// The `color` parameter is a color representing the color of the card.
  CourseCard({
    super.key,
    required this.name,
    required this.color,
    required this.onLongPress,
  });

  Future<void> deleteCourse() async {
    Course? course = await _courseController.getCourseByName(courseName: name);
    await _courseController.deleteCourse(course!);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        top: 8.0,
        left: 16.0,
        right: 16.0,
      ),
      child: Card(
        color: color.withOpacity(0.333),
        child: Padding(
          padding: const EdgeInsets.all(1.0),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6.0),
            ),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CourseView(
                      courseName: name,
                    ),
                  ),
                );
              },
              onLongPress: onLongPress,
              borderRadius: BorderRadius.circular(6.0),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      children: [
                        Text(
                          name,
                          style: CustomTextStyle.titleStyle,
                        ),
                        const Spacer(),
                        Icon(
                          Symbols.circle,
                          color: color,
                          size: 25,
                          weight: 1000,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
