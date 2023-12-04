import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import './components/app_bar.dart';
import './components/nav_drawer.dart';
import './styles/text_style.dart';
import './components/deliverables_card.dart';

class CourseGradesView extends StatefulWidget {
  final String name;
  final Color color;

  const CourseGradesView({super.key, required this.name, required this.color});

  @override
  CourseGradesViewState createState() => CourseGradesViewState();
}

class CourseGradesViewState extends State<CourseGradesView> {
  double average = 100;
  double gradeWanted = 100;
  late DateTime _selectedDate;
  late TimeOfDay _selectedTime;
  final TextEditingController _weightController = TextEditingController();
  String? weightErrorText;

  Future<void> _selectDate(BuildContext context, StateSetter setState) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
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

  double calculateNeededGrade(double average, double gradeWanted) {
    double remainingPercentage = 50;
    double currentPercentage = 100 - remainingPercentage;
    double currentGrade = average * (currentPercentage / 100);
    double remainingGrade = gradeWanted - currentGrade;
    double neededGrade = remainingGrade / (remainingPercentage / 100);
    return neededGrade;
  }

  @override
  Widget build(BuildContext context) {
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
                seedColor: widget.color,
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
                seedColor: widget.color,
                brightness: Theme.of(context).brightness,
              ),
              bottomSheetTheme: const BottomSheetThemeData(
                showDragHandle: true,
              ),
            ),
      child: Builder(
        builder: (context) {
          return Scaffold(
            drawer: const NavDrawer(),
            appBar: const CustomAppBar(),
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
                          widget.name,
                          style: CustomTextStyle.titleStyle,
                        ),
                        const Spacer(),
                        Icon(
                          Symbols.circle,
                          color: widget.color,
                        ),
                      ],
                    ),
                    const Divider(
                      thickness: 2,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 6.0,
                        bottom: 6.0,
                      ),
                      child: Row(
                        children: [
                          Text(
                            'Average',
                            style: CustomTextStyle.bodyStyle,
                          ),
                          const Spacer(),
                          Text(
                            "$average",
                            style: CustomTextStyle.bodyStyle,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 6.0,
                        bottom: 6.0,
                      ),
                      child: Row(
                        children: [
                          Text(
                            'Grade Needed',
                            style: CustomTextStyle.bodyStyle,
                          ),
                          const Spacer(),
                          Text(
                            '${calculateNeededGrade(average, gradeWanted)}',
                            style: CustomTextStyle.bodyStyle,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 6.0,
                        bottom: 6.0,
                      ),
                      child: Row(
                        children: [
                          Text(
                            'Grade Wanted',
                            style: CustomTextStyle.bodyStyle,
                          ),
                          const Spacer(),
                          Container(
                            height: 40,
                            width: 80,
                            alignment: Alignment.center,
                            child: TextField(
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.all(10.0),
                                helperStyle: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  fontSize: CustomTextStyle.bodyStyle.fontSize,
                                ),
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
                                hintText: '$gradeWanted',
                              ),
                              textAlign: TextAlign.end,
                              style: CustomTextStyle.bodyStyle,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                  RegExp(r'^\d+(\.\d+)?$'),
                                ),
                              ],
                              onChanged: (value) {
                                setState(() {
                                  gradeWanted = double.parse(value);
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Text(
                          'Deliverables',
                          style: CustomTextStyle.titleStyle,
                        ),
                      ],
                    ),
                    const Divider(
                      thickness: 2,
                    ),
                    for (int i = 0; i < 10; i++)
                      DeliverablesCard(
                        name: 'Assignment $i',
                        color: widget.color,
                        weight: 10,
                        dueDate: DateTime.now(),
                        dueTime: const TimeOfDay(hour: 23, minute: 59),
                        padding: false,
                        onTap: () => showBottomModal(
                          'Assignment $i',
                          10,
                          DateTime.now(),
                          const TimeOfDay(hour: 23, minute: 59),
                          context,
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
