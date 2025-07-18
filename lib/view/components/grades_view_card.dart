import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../model/course.dart';
import '../course_grades.dart';
import '../styles/text_style.dart';

class GradesCard extends StatelessWidget {
  final String name;
  final Color color;
  final Course course;

  /// Creates a card that displays the average for a course and how much is needed to get x %.
  ///
  /// The `name` parameter is a string representing the name of the course.
  /// The `color` parameter is a color representing the color of the card.
  const GradesCard({
    super.key,
    required this.name,
    required this.color,
    required this.course,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        top: 8.0,
        left: 16.0,
        right: 16.0,
      ),
      height: MediaQuery.of(context).size.height * 0.17,
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
                    builder: (context) => CourseGradesView(
                      course: course,
                      name: name,
                      color: color,
                    ),
                  ),
                );
              },
              borderRadius: BorderRadius.circular(6.0),
              child: Padding(
                padding: CustomTextStyle.defaultPadding,
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
                    Divider(color: color),
                    course.currentGrade == null ||
                            course.gradeWanted == null ||
                            course.gradeNeeded == null
                        ? const Text(
                            'Configure grades by tapping on this card!',
                          )
                        : Column(
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'Grade',
                                    style: CustomTextStyle.bodyStyle,
                                  ),
                                  const Spacer(),
                                  Text(
                                    course.currentGrade!.round().toString(),
                                    style: CustomTextStyle.bodyStyle,
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    'Needed to get ${course.gradeWanted?.round().toString()}%',
                                    style: CustomTextStyle.bodyStyle,
                                  ),
                                  const Spacer(),
                                  Text(
                                    '${course.gradeNeeded?.round().toString()}%',
                                    style: CustomTextStyle.bodyStyle,
                                  ),
                                ],
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
