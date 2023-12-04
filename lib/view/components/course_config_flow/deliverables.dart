import 'package:course_compass/controller/timeslot_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../controller/deliverable_controller.dart';
import '../../../model/course.dart';
import '../../../model/deliverable.dart';
import '../deliverables_card.dart';

class CourseConfigDeliverables extends StatefulWidget {
  final Course? course;
  const CourseConfigDeliverables({
    super.key,
    required this.course,
  });

  @override
  State<CourseConfigDeliverables> createState() =>
      _CourseConfigDeliverablesState();
}

class _CourseConfigDeliverablesState extends State<CourseConfigDeliverables> {
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  String? weightErrorText;
  late DeliverableController deliverableController =
      DeliverableController(course: widget.course);
  List<Widget> widgets = [];

  Future<void> _selectDate(BuildContext context, StateSetter setState) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: widget.course!.end,
    );
    if (picked != null) {
      setState(
        () {
          _selectedDate = picked;
        },
      );
    }
  }

  Future<void> _selectTime(BuildContext context, StateSetter setState) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  @override
  void initState() {
    super.initState();
  }

  showBottomModal(
    String name,
    double weight,
    DateTime dueDate,
    TimeOfDay dueTime,
  ) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Column(
            children: [
              Text('Name: $name'),
              Text('Weight: $weight'),
              Text('Due Date: $dueDate'),
              Text('Due Time: $dueTime'),
            ],
          );
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: deliverableController.getStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          List<Deliverable>? deliverables = snapshot.data!.docs
              .map((doc) => Deliverable.fromMap(doc))
              .toList();
          widgets = [];
          for (int i = 0; i < deliverables.length; i++) {
            final deliverable = deliverables[i];
            widgets.add(
              DeliverablesCard(
                name: deliverable.name,
                color: Theme.of(context).colorScheme.secondary,
                weight: deliverable.weight,
                grade: deliverable.grade,
                dueDate: deliverable.due,
                dueTime: TimeOfDay(
                  hour: deliverable.due.hour,
                  minute: deliverable.due.minute,
                ),
                onTap: null,
              ),
            );
          }
        }
        return Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
            title: const Text('Deliverables'),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: ElevatedButton(
                  onPressed: () {
                    TimeslotController timeslotController = TimeslotController(
                      course: widget.course,
                    );
                    timeslotController.fillSchedule();
                    Navigator.of(context).popAndPushNamed('/home');
                  },
                  child: const Text('Done'),
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
                            bottom: MediaQuery.of(context).viewInsets.bottom,
                          ),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextField(
                                    controller: _nameController,
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
                                      labelText: 'Deliverable Name',
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  TextField(
                                    controller: _weightController,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter.allow(
                                        RegExp(r'[0-9]'),
                                      ),
                                    ],
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
                                      labelText: 'Weight (%)',
                                      hintText:
                                          'Enter a value between 0 and 100',
                                      errorText: weightErrorText,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Row(
                                        children: [
                                          Icon(Icons.calendar_month),
                                          SizedBox(width: 6),
                                          Text(
                                            style: TextStyle(fontSize: 20),
                                            'Due Date',
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            style:
                                                const TextStyle(fontSize: 20),
                                            _selectedDate
                                                .toLocal()
                                                .toString()
                                                .split(' ')[0],
                                          ),
                                          IconButton(
                                            onPressed: () =>
                                                _selectDate(context, setState),
                                            icon: const Icon(Icons.edit),
                                          ),
                                        ],
                                      ),
                                    ],
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
                                            'Due Time',
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            style:
                                                const TextStyle(fontSize: 20),
                                            '${_selectedTime.hour}:${_selectedTime.minute.toString().padLeft(2, '0')}',
                                          ),
                                          IconButton(
                                            onPressed: () =>
                                                _selectTime(context, setState),
                                            icon: const Icon(Icons.edit),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      TextButton(
                                        onPressed: () {
                                          String errorText = _validateWeight();
                                          if (errorText.isEmpty) {
                                            DateTime dueDateTime = DateTime(
                                              _selectedDate.year,
                                              _selectedDate.month,
                                              _selectedDate.day,
                                              _selectedTime.hour,
                                              _selectedTime.minute,
                                            );
                                            Deliverable deliverable =
                                                Deliverable(
                                              name: _nameController.text,
                                              due: dueDateTime,
                                              weight: double.parse(
                                                _weightController.text,
                                              ),
                                            );
                                            DeliverableController
                                                deliverableController =
                                                DeliverableController(
                                              course: widget.course,
                                            );
                                            deliverableController
                                                .createDeliverable(deliverable);
                                            Navigator.of(context).pop();
                                          } else {
                                            setState(
                                              () {
                                                weightErrorText = errorText;
                                              },
                                            );
                                          }
                                        },
                                        child: const Text(
                                          style: TextStyle(fontSize: 15),
                                          'Save Deliverable',
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
            tooltip: 'Add a Deliverable',
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
  }

  String _validateWeight() {
    // Validate that the entered value is between 0 and 100
    try {
      int weight = int.parse(_weightController.text);
      if (weight < 0 || weight > 100) {
        return 'Weight must be between 0 and 100';
      }
    } catch (e) {
      return 'Invalid numeric input';
    }
    return ''; // No validation error
  }
}
