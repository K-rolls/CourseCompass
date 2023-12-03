import 'package:course_compass/view/styles/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_symbols_icons/symbols.dart';

import './components/app_bar.dart';
import './components/nav_drawer.dart';
import './components/deliverables_card.dart';
import './components/timeslot_card.dart';
import './styles/course_colors.dart';

class CourseView extends StatefulWidget {
  final String courseName;

  const CourseView({super.key, required this.courseName});

  @override
  CourseViewState createState() => CourseViewState();
}

class CourseViewState extends State<CourseView> {
  late DateTime _selectedDate;
  late TimeOfDay _selectedTime;
  final TextEditingController _weightController = TextEditingController();
  String? weightErrorText;
  late String questions = '';
  late Color color = Colors.blueGrey;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _selectedTime = const TimeOfDay(hour: 23, minute: 59);
    _weightController.addListener(() {
      setState(() {
        weightErrorText = _validateWeight();
      });
    });
    questions = 'Question 1\nQuestion 2\nQuestion 3\nQuestion 4\nQuestion 5';
    color = Colors.blueGrey;
  }

  Future<void> _selectDate(BuildContext context, StateSetter setState) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      // TODO: needs to be set to start of course
      firstDate: DateTime(2000),
      // TODO: needs to be set to end of course
      lastDate: DateTime(
        DateTime.now().year,
        12,
        31,
      ),
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

  bool _showDeliverables = true;

  @override
  Widget build(BuildContext context) {
    double? buttonFontSize = Theme.of(context).textTheme.bodySmall!.fontSize;
    // ignore: prefer_function_declarations_over_variables
    final showBottomModal = (
      String name,
      double weight,
      DateTime dueDate,
      TimeOfDay dueTime,
      BuildContext context,
    ) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _selectedDate = dueDate;
        _selectedTime = dueTime;
        showModalBottomSheet(
          backgroundColor: Theme.of(context).colorScheme.background,
          context: context,
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
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                    width: 2.0,
                                  ),
                                ),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                    width: 2.0,
                                  ),
                                ),
                                labelText: name,
                              ),
                            ),
                            const SizedBox(height: 20),
                            TextField(
                              controller: _weightController,
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.allow(
                                  RegExp(r'^\d*\.?\d*$'),
                                ),
                              ],
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                    width: 2.0,
                                  ),
                                ),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                    width: 2.0,
                                  ),
                                ),
                                labelText: '$weight %',
                                hintText: 'Enter a value between 0 and 100',
                                errorText: weightErrorText,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                      // TODO: Process the entered values
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
        );
      });
    };
    return Theme(
      data: Theme.of(context).brightness == Brightness.light
          ? ThemeData.light(
              useMaterial3: true,
            ).copyWith(
              colorScheme: ColorScheme.fromSeed(
                seedColor: color,
                brightness: Theme.of(context).brightness,
              ),
              bottomSheetTheme: const BottomSheetThemeData(
                showDragHandle: true,
              ),
            )
          : ThemeData.dark(
              useMaterial3: true,
            ).copyWith(
              colorScheme: ColorScheme.fromSeed(
                seedColor: color,
                brightness: Theme.of(context).brightness,
              ),
              bottomSheetTheme: const BottomSheetThemeData(
                showDragHandle: true,
              ),
            ),
      child: StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Scaffold(
            appBar: const CustomAppBar(),
            drawer: const NavDrawer(),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          widget.courseName,
                          style: CustomTextStyle.titleStyle,
                        ),
                        const Spacer(),
                        IconButton(
                          icon: Icon(
                            Symbols.circle,
                            color: color,
                          ),
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
                                                courseColors.length, (index) {
                                              final color = courseColors[index];
                                              return IconButton(
                                                icon: Icon(
                                                  Icons.circle,
                                                  color: color[0],
                                                  size: 40,
                                                ),
                                                tooltip: color[1],
                                                onPressed: () {
                                                  super.setState(() {
                                                    this.color = color[0];
                                                  });
                                                  Navigator.pop(
                                                    context,
                                                  ); // Close the bottom sheet
                                                },
                                              );
                                            }),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    const Divider(
                      thickness: 2,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Form(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            TextFormField(
                              maxLines: null, // Allows newlines
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Questions',
                              ),
                              initialValue: questions,
                              onChanged: (value) {
                                setState(() {
                                  questions = value;
                                });
                              },
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: SizedBox(
                                height: buttonFontSize! + 10,
                                child: TextButton(
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        backgroundColor: Theme.of(context)
                                            .colorScheme
                                            .surfaceVariant,
                                        content: Text(
                                          'Saving Questions...',
                                          style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurfaceVariant,
                                          ),
                                        ),
                                      ),
                                    );
                                    // TODO: save the questions to firebase
                                  },
                                  style: const ButtonStyle(
                                    padding: MaterialStatePropertyAll<
                                        EdgeInsetsGeometry>(
                                      EdgeInsets.only(right: -4),
                                    ),
                                  ),
                                  child: Text(
                                    'Save Questions',
                                    textAlign: TextAlign.end,
                                    style: TextStyle(
                                      fontSize: buttonFontSize,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _showDeliverables = true;
                            });
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: _showDeliverables
                                ? Theme.of(context)
                                    .colorScheme
                                    .onPrimaryContainer
                                : Theme.of(context)
                                    .colorScheme
                                    .onSecondaryContainer,
                            backgroundColor: _showDeliverables
                                ? Theme.of(context).colorScheme.primaryContainer
                                : Theme.of(context)
                                    .colorScheme
                                    .secondaryContainer,
                          ),
                          child: const Text('Deliverables'),
                        ),
                        const SizedBox(width: 8),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _showDeliverables = false;
                            });
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: !_showDeliverables
                                ? Theme.of(context)
                                    .colorScheme
                                    .onPrimaryContainer
                                : Theme.of(context)
                                    .colorScheme
                                    .onSecondaryContainer,
                            backgroundColor: !_showDeliverables
                                ? Theme.of(context).colorScheme.primaryContainer
                                : Theme.of(context)
                                    .colorScheme
                                    .secondaryContainer,
                          ),
                          child: const Text('Time Slots'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    if (_showDeliverables)
                      Column(
                        children: List.generate(
                          10,
                          (index) => DeliverablesCard(
                            color: color,
                            name: 'Assignment $index',
                            dueDate: DateTime.now(),
                            weight: 10.0,
                            dueTime: const TimeOfDay(hour: 23, minute: 59),
                            padding: false,
                            onTap: () => showBottomModal(
                              'Assignment $index',
                              10,
                              DateTime.now(),
                              const TimeOfDay(hour: 23, minute: 59),
                              context,
                            ),
                          ),
                        ),
                      ),
                    if (!_showDeliverables)
                      Column(
                        children: List.generate(
                          3,
                          (index) => TimeslotCard(
                            name: "Lecture ${index + 1}",
                            color: color,
                            weekDays: index % 2 == 0
                                ? [
                                    false,
                                    true,
                                    false,
                                    true,
                                    false,
                                    true,
                                    false,
                                  ]
                                : [
                                    false,
                                    false,
                                    true,
                                    false,
                                    true,
                                    false,
                                    false,
                                  ],
                            startTime: const TimeOfDay(hour: 10, minute: 30),
                            padding: false,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
