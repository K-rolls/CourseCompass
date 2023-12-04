import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:course_compass/controller/timeslot_controller.dart';
import 'package:flutter/material.dart';
import 'package:weekday_selector/weekday_selector.dart';

import '../../../model/course.dart';
import '../../../model/timeslot.dart';
import '../timeslot_card.dart';
import 'deliverables.dart';

class CourseConfigSchedule extends StatefulWidget {
  final Course? course;

  const CourseConfigSchedule({
    super.key,
    required this.course,
  });

  @override
  State<CourseConfigSchedule> createState() => _CourseConfigScheduleState();
}

class _CourseConfigScheduleState extends State<CourseConfigSchedule> {
  TimeOfDay _selectedTime = TimeOfDay.now();
  final TextEditingController timeslotNameController = TextEditingController();
  final List<dynamic> values = List.filled(7, false);
  late TimeslotController timeslotController = TimeslotController(
    course: widget.course,
  );
  List<Widget> widgets = [];
  bool stateChange = true;

  Future<void> _selectTime(BuildContext context, StateSetter setState) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null) {
      setState(
        () {
          _selectedTime = picked;
        },
      );
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: timeslotController.getStream(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          List<Timeslot>? timeslots =
              snapshot.data!.docs.map((doc) => Timeslot.fromMap(doc)).toList();
          widgets = [];
          for (int i = 0; i < timeslots.length; i++) {
            final timeslot = timeslots[i];
            widgets.add(
              TimeslotCard(
                name: timeslot.name,
                color: Colors.blueGrey,
                weekDays: timeslot.days,
                startTime: timeslot.time,
              ),
            );
          }
        }

        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Scaffold(
              resizeToAvoidBottomInset: true,
              appBar: AppBar(
                backgroundColor:
                    Theme.of(context).colorScheme.secondaryContainer,
                title: const Text('Add Schedule'),
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) =>
                                CourseConfigDeliverables(
                              course: widget.course,
                            ),
                          ),
                        );
                      },
                      child: const Text('Next'),
                    ),
                  ),
                ],
              ),
              floatingActionButton: FloatingActionButton.extended(
                isExtended: true,
                onPressed: () => {
                  showModalBottomSheet(
                    backgroundColor:
                        Theme.of(context).colorScheme.secondaryContainer,
                    context: context,
                    isScrollControlled: true,
                    builder: (BuildContext context) {
                      return StatefulBuilder(
                        builder: (BuildContext context, StateSetter setState) {
                          return SingleChildScrollView(
                            child: Padding(
                              padding: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom,
                              ),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      TextField(
                                        controller: timeslotNameController,
                                        decoration: InputDecoration(
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary,
                                              width: 2.0,
                                            ),
                                          ),
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary,
                                              width: 2.0,
                                            ),
                                          ),
                                          labelText: 'Timeslot Name',
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: WeekdaySelector(
                                          firstDayOfWeek: 0,
                                          onChanged: (int day) {
                                            setState(
                                              () {
                                                final index = day % 7;
                                                values[index] = !values[index];
                                              },
                                            );
                                          },
                                          values: values
                                              .map((item) => item as bool?)
                                              .toList(),
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Row(
                                            children: [
                                              Icon(Icons.schedule),
                                              SizedBox(width: 6),
                                              Text(
                                                style: TextStyle(fontSize: 20),
                                                'Start Time',
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                style: const TextStyle(
                                                  fontSize: 20,
                                                ),
                                                '${_selectedTime.hour}:${_selectedTime.minute.toString().padLeft(2, '0')}',
                                              ),
                                              IconButton(
                                                onPressed: () => _selectTime(
                                                  context,
                                                  setState,
                                                ),
                                                icon: const Icon(Icons.edit),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 16),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          TextButton(
                                            onPressed: () {
                                              DateTime now = DateTime.now();
                                              DateTime time = DateTime(
                                                now.year,
                                                now.month,
                                                now.day,
                                                _selectedTime.hour,
                                                _selectedTime.minute,
                                              );
                                              Timeslot timeslot = Timeslot(
                                                name:
                                                    timeslotNameController.text,
                                                days: values,
                                                time: time,
                                              );

                                              TimeslotController
                                                  timeslotController =
                                                  TimeslotController(
                                                course: widget.course,
                                              );
                                              setState(() {
                                                timeslotController
                                                    .createTimeslot(timeslot);
                                              });

                                              Navigator.of(context).pop();
                                            },
                                            child: const Text(
                                              style: TextStyle(fontSize: 15),
                                              'Save Timeslot',
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                },
                tooltip: 'Add a Timeslot',
                icon: const Icon(Icons.add),
                label: const Text(
                  'New',
                  style: TextStyle(fontSize: 15),
                ),
              ),
              body: Center(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ListView(
                    children: widgets,
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
