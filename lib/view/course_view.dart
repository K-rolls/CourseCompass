import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../controller/course_controller.dart';
import '../controller/deliverable_controller.dart';
import '../controller/timeslot_controller.dart';
import '../model/course.dart';
import '../model/deliverable.dart';
import '../model/timeslot.dart';

import './components/app_bar.dart';
import './components/deliverables_card.dart';
import './components/nav_drawer.dart';
import './components/timeslot_card.dart';
import './styles/course_colors.dart';
import './styles/text_style.dart';

class CourseView extends StatefulWidget {
  final String courseName;

  const CourseView({super.key, required this.courseName});

  @override
  CourseViewState createState() => CourseViewState();
}

class CourseViewState extends State<CourseView> {
  late DateTime _selectedDate;
  late TimeOfDay _selectedTime;
  late final DateTime _startDate;
  late final DateTime _endDate;

  final TextEditingController _weightController = TextEditingController();
  String? _weightErrorText;
  late String _questions;
  late Color _color = Colors.blueGrey;
  final CourseController _courseController = CourseController();
  late final DeliverableController _deliverableController;
  late List<Deliverable> _deliverables = [];
  late final TimeslotController _timeslotController;
  late List<Timeslot> _timeslots = [];
  late bool _showDeliverables;
  late final Course? course;
  bool loaded = false;

  @override
  void initState() {
    super.initState();
    _showDeliverables = true;
    _selectedDate = DateTime.now();
    _selectedTime = const TimeOfDay(hour: 23, minute: 59);
    _weightController.addListener(_updateWeightErrorText);
    Future.delayed(Duration.zero, () async {
      await _fetchCourseData().then((_) {
        super.setState(() {
          loaded = true;
        });
      });
    });
  }

  void _updateWeightErrorText() {
    setState(() {
      _weightErrorText = _validateWeight();
    });
  }

  Future<void> _fetchCourseData() async {
    course =
        await _courseController.getCourseByName(courseName: widget.courseName);
    super.setState(() {
      _questions = course!.questions ?? '';
      _color = course!.color ?? Colors.blueGrey;
      _endDate = course!.end;
      _startDate = course!.start;
      _deliverableController = DeliverableController(course: course);
      _timeslotController = TimeslotController(course: course);
    });
    var deliverablesWaited = await _deliverableController.listDeliverables();
    var timeslotsWaited = await _timeslotController.listTimeslots();
    setState(() {
      _deliverables = deliverablesWaited;
      _timeslots = timeslotsWaited;
    });
  }

  @override
  void dispose() {
    _weightController.dispose();
    super.dispose();
  }

  Future<void> updateColor() async {
    if (_color != course!.color) {
      var newCourse = Course(
        id: course!.id,
        color: _color,
        name: course!.name,
        start: course!.start,
        end: course!.end,
        questions: course!.questions,
      );
      await _courseController
          .updateCourse(newCourse)
          .then(Navigator.of(context).pop);
    }
  }

  Future<void> updateQuestions() async {
    if (_questions != course!.questions) {
      var newCourse = Course(
        id: course!.id,
        color: course!.color,
        name: course!.name,
        start: course!.start,
        end: course!.end,
        questions: _questions,
      );
      await _courseController.updateCourse(newCourse);
    }
  }

  Future<void> _selectDate(BuildContext context, StateSetter setState) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: _startDate,
      lastDate: _endDate,
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
                                errorText: _weightErrorText,
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
                                        _weightErrorText = errorText;
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
    if (!loaded) {
      return const Scaffold(
        appBar: CustomAppBar(),
        drawer: NavDrawer(),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return Theme(
        data: Theme.of(context).brightness == Brightness.light
            ? ThemeData.light(
                useMaterial3: true,
              ).copyWith(
                colorScheme: ColorScheme.fromSeed(
                  seedColor: _color,
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
                  seedColor: _color,
                  brightness: Theme.of(context).brightness,
                ),
                bottomSheetTheme: const BottomSheetThemeData(
                  showDragHandle: true,
                ),
              ),
        child: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
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
                            widget.courseName,
                            style: CustomTextStyle.titleStyle,
                          ),
                          const Spacer(),
                          IconButton(
                            icon: Icon(
                              Symbols.circle,
                              color: _color,
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
                                                final color =
                                                    courseColors[index];
                                                return IconButton(
                                                  icon: Icon(
                                                    Icons.circle,
                                                    color: color[0],
                                                    size: 40,
                                                  ),
                                                  tooltip: color[1],
                                                  onPressed: () async {
                                                    super.setState(() {
                                                      _color = color[0];
                                                    }); // Close the bottom sheet
                                                    await updateColor();
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
                                initialValue: _questions,
                                onChanged: (value) {
                                  setState(() {
                                    _questions = value;
                                  });
                                },
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: SizedBox(
                                  height: buttonFontSize! + 10,
                                  child: TextButton(
                                    onPressed: () async {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          duration:
                                              const Duration(milliseconds: 500),
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
                                      await updateQuestions();
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
                                  ? Theme.of(context)
                                      .colorScheme
                                      .primaryContainer
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
                                  ? Theme.of(context)
                                      .colorScheme
                                      .primaryContainer
                                  : Theme.of(context)
                                      .colorScheme
                                      .secondaryContainer,
                            ),
                            child: const Text('Time Slots'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Column(
                        children: [
                          if (_showDeliverables && _deliverables.isNotEmpty)
                            Column(
                              children: _deliverables
                                  .map(
                                    (deliverable) => DeliverablesCard(
                                      color: _color,
                                      name: deliverable.name,
                                      dueDate: deliverable.due,
                                      weight: deliverable.weight,
                                      dueTime: TimeOfDay.fromDateTime(
                                        deliverable.due.toLocal(),
                                      ),
                                      padding: false,
                                      onTap: () => showBottomModal(
                                        deliverable.name,
                                        deliverable.weight,
                                        deliverable.due,
                                        TimeOfDay.fromDateTime(
                                          deliverable.due.toLocal(),
                                        ),
                                        context,
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                          if (!_showDeliverables && _timeslots.isNotEmpty)
                            Column(
                              children: _timeslots
                                  .map(
                                    (timeslot) => TimeslotCard(
                                      name: timeslot.name,
                                      color: _color,
                                      weekDays: (timeslot.days).cast<bool>(),
                                      startTime: timeslot.time,
                                      padding: false,
                                    ),
                                  )
                                  .toList(),
                            ),
                          if (_showDeliverables && _deliverables.isEmpty)
                            const Center(
                              child: Text(
                                'No deliverables have been added yet.',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          if (!_showDeliverables && _timeslots.isEmpty)
                            const Center(
                              child: Text(
                                'No time slots have been added yet.',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                        ],
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
}
