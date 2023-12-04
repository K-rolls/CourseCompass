import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../styles/text_style.dart';
import '../course_view.dart';

class DueDateCard extends StatelessWidget {
  final String name;
  final DateTime dueDate;
  final Color color;
  final String courseName;

  /// Creates a card that displays a deliverable due on the date selected.
  ///
  /// The `name` parameter is a string representing the name of the course.
  /// The `color` parameter is a color representing the color of the card.
  /// The `dueDate` parameter is the due date of the deliverable.
  const DueDateCard({
    super.key,
    required this.name,
    required this.dueDate,
    required this.color,
    required this.courseName,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: const EdgeInsets.only(
          top: 4.0,
          left: 2.0,
          right: 2.0,
        ),
        child: Card(
          color: color.withOpacity(0.333),
          child: Padding(
            padding: const EdgeInsets.all(1.0),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CourseView(courseName: courseName),
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(8.0),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
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
                      const Divider(),
                      Row(
                        children: [
                          Text(
                            courseName,
                            style: CustomTextStyle.bodyStyle,
                          ),
                          const Spacer(),
                          Text(
                            DateFormat.MMMd().add_jm().format(dueDate),
                            style: CustomTextStyle.bodyStyle,
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
      ),
    );
  }
}
