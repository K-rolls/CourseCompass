import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../deliverables_card.dart';

class CourseConfigDeliverables extends StatefulWidget {
  const CourseConfigDeliverables({super.key});

  @override
  State<CourseConfigDeliverables> createState() =>
      _CourseConfigDeliverablesState();
}

class _CourseConfigDeliverablesState extends State<CourseConfigDeliverables> {
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  final TextEditingController _weightController = TextEditingController();
  String? weightErrorText;

  Future<void> _selectDate(BuildContext context, StateSetter setState) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
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
  Widget build(BuildContext context) {
    return Dialog.fullscreen(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
          title: const Text('Deliverables'),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child:
                  ElevatedButton(onPressed: () {}, child: const Text('Next')),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          isExtended: true,
          onPressed: () => {
            showModalBottomSheet(
              backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
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
                                    hintText: 'Enter a value between 0 and 100',
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
                                          style: const TextStyle(fontSize: 20),
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
                                          style: const TextStyle(fontSize: 20),
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
                                          // Process the entered values
                                          Navigator.of(context).pop();
                                        } else {
                                          setState(() {
                                            weightErrorText = errorText;
                                          });
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
            //Placeholder widgets for now
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                DeliverablesCard(
                  name: 'A1',
                  color: Colors.blue,
                  weight: 10,
                  dueDate: DateTime.now(),
                  dueTime: TimeOfDay.now(),
                ),
                DeliverablesCard(
                  name: 'A2',
                  color: Colors.blue,
                  weight: 10,
                  dueDate: DateTime.now(),
                  dueTime: TimeOfDay.now(),
                ),
              ],
            ),
          ),
        ),
      ),
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
