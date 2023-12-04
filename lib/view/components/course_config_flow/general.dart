import 'package:flutter/material.dart';

import '../../../controller/course_controller.dart';
import '../../../controller/parse_controller.dart';
import '../../../model/course.dart';
import 'schedule.dart';

final List<List<dynamic>> _colors = [
  [Colors.blueGrey, 'Default'],
  [Colors.indigo, 'Indigo'],
  [Colors.teal, 'Teal'],
  [Colors.green, 'Green'],
  [Colors.amber, 'Amber'],
  [Colors.deepOrange, 'Deep Orange'],
  [Colors.pinkAccent, 'Pink'],
  [const Color(0xFF800020), 'Burgundy Red'],
];

class CourseConfigGeneral extends StatefulWidget {
  const CourseConfigGeneral({super.key});

  @override
  State<CourseConfigGeneral> createState() => _CourseConfigGeneralState();
}

class _CourseConfigGeneralState extends State<CourseConfigGeneral> {
  final TextEditingController courseNameController = TextEditingController();
  DateTime _selectedStartDate = DateTime.now();
  DateTime _selectedEndDate = DateTime.now();
  late Color _color = Colors.blueGrey;

  Future<void> _selectStartDate(
    BuildContext context,
    StateSetter setState,
  ) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedStartDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2050),
    );
    if (picked != null) {
      setState(
        () {
          _selectedStartDate = picked;
        },
      );
    }
  }

  Future<void> _selectEndDate(
    BuildContext context,
    StateSetter setState,
  ) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedEndDate,
      firstDate: _selectedStartDate,
      lastDate: DateTime(2050),
    );
    if (picked != null) {
      setState(
        () {
          _selectedEndDate = picked;
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
            title: const Text('General'),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: ElevatedButton(
                  onPressed: () async {
                    Course? course = Course(
                      name: courseNameController.text,
                      start: _selectedStartDate,
                      end: _selectedEndDate,
                      color: _color,
                    );
                    CourseController courseController = CourseController();
                    course = await courseController.createCourse(course);
                    // ignore: use_build_context_synchronously
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => CourseConfigSchedule(
                          course: course,
                        ),
                      ),
                    );
                  },
                  child: const Text('Next'),
                ),
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 500,
                    child: TextField(
                      controller: courseNameController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Enter course name',
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  SizedBox(
                    width: 500,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.calendar_month),
                            Text(
                              'Select Start Date:',
                              style: TextStyle(fontSize: 15),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _selectedStartDate
                                  .toLocal()
                                  .toString()
                                  .split(' ')[0],
                              style: const TextStyle(fontSize: 15),
                            ),
                            IconButton(
                              onPressed: () =>
                                  _selectStartDate(context, setState),
                              icon: const Icon(Icons.edit),
                              iconSize: 20,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 500,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.calendar_month),
                            Text(
                              'Select End Date:',
                              style: TextStyle(fontSize: 15),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _selectedEndDate
                                  .toLocal()
                                  .toString()
                                  .split(' ')[0],
                              style: const TextStyle(fontSize: 15),
                            ),
                            IconButton(
                              onPressed: () =>
                                  _selectEndDate(context, setState),
                              icon: const Icon(Icons.edit),
                              iconSize: 20,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Autofill schedule from PDF'),
                      const SizedBox(width: 10),
                      IconButton(
                        onPressed: () async {
                          Course? course = Course(
                            name: courseNameController.text,
                            start: _selectedStartDate,
                            end: _selectedEndDate,
                          );
                          CourseController courseController =
                              CourseController();
                          course = await courseController.createCourse(course);
                          await ParseController.addSyllabusFromPDF(course);
                          // ignore: use_build_context_synchronously
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  CourseConfigSchedule(
                                course: course,
                              ),
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.save,
                        ),
                        iconSize: 38,
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 500,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Course Color',
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                        FilledButton(
                          onPressed: () => showModalBottomSheet(
                            backgroundColor: Theme.of(context)
                                .colorScheme
                                .secondaryContainer,
                            context: context,
                            isScrollControlled: true,
                            builder: (BuildContext context) {
                              return StatefulBuilder(
                                builder: (
                                  BuildContext context,
                                  StateSetter setState,
                                ) {
                                  return SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          GridView.count(
                                            shrinkWrap: true,
                                            crossAxisCount: 4,
                                            children: List.generate(
                                              _colors.length,
                                              (index) {
                                                final color = _colors[index];
                                                return IconButton(
                                                  icon: Icon(
                                                    Icons.circle,
                                                    color: color[0],
                                                    size: 40,
                                                  ),
                                                  tooltip: color[1],
                                                  onPressed: () {
                                                    super.setState(
                                                      () {
                                                        _color = color[0];
                                                      },
                                                    );
                                                  },
                                                );
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                          style: ElevatedButton.styleFrom(
                            shape: const CircleBorder(),
                            backgroundColor: _color,
                          ),
                          child: Container(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
