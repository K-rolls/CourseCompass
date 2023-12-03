import 'package:flutter/material.dart';
import 'package:weekday_selector/weekday_selector.dart';

import '../../timeslot_card.dart';

class CourseConfigSchedule extends StatefulWidget {
  const CourseConfigSchedule({super.key});

  @override
  State<CourseConfigSchedule> createState() => _CourseConfigScheduleState();
}

class _CourseConfigScheduleState extends State<CourseConfigSchedule> {
  TimeOfDay _selectedTime = TimeOfDay.now();
  final values = List.filled(7, false);

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
          title: const Text('Weekly Course Schedule'),
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
                                    labelText: 'Timeslot Name',
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: WeekdaySelector(
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
                                    selectedColor: Theme.of(context)
                                        .colorScheme
                                        .onPrimaryContainer,
                                    fillColor:
                                        Theme.of(context).colorScheme.surface,
                                    selectedFillColor: Theme.of(context)
                                        .colorScheme
                                        .primaryContainer,
                                    firstDayOfWeek: 0,
                                    onChanged: (int day) {
                                      setState(() {
                                        final index = day % 7;
                                        values[index] = !values[index];
                                      });
                                    },
                                    values: values,
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
                                      onPressed: () {},
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
        body: const Center(
          child: Padding(
            //Placeholder widgets for now
            padding: EdgeInsets.all(10.0),
            child: Column(
              children: [
                TimeslotCard(
                  name: 'Lecture',
                  color: Colors.blue,
                  weekDays: [false, true, false, true, false, true, false],
                  startTime: TimeOfDay(hour: 9, minute: 0),
                ),
                TimeslotCard(
                  name: 'Lab',
                  color: Colors.blue,
                  weekDays: [false, false, true, false, false, false, false],
                  startTime: TimeOfDay(hour: 13, minute: 0),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
