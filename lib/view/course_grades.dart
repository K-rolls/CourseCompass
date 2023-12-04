import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../controller/course_controller.dart';
import '../model/course.dart';
import '../model/deliverable.dart';
import './components/app_bar.dart';
import './components/nav_drawer.dart';
import './styles/text_style.dart';
import './components/deliverables_card.dart';
import '../../../controller/deliverable_controller.dart';

class CourseGradesView extends StatefulWidget {
  final String name;
  final Color color;
  final Course course;

  const CourseGradesView({
    super.key,
    required this.name,
    required this.color,
    required this.course,
  });

  @override
  CourseGradesViewState createState() => CourseGradesViewState();
}

class CourseGradesViewState extends State<CourseGradesView> {
  late double average;
  late double gradeWanted;
  late double gradeNeeded;
  final TextEditingController _gradeController = TextEditingController();
  late DeliverableController deliverableController;
  late CourseController courseController;
  List<Deliverable> deliverablesList = [];
  String? gradeErrorText;

  String _validateGrade() {
    // Validate that the entered value is between 0 and 100
    try {
      double grade = double.parse(_gradeController.text);
      if (grade < 0.0 || grade > 100.0) {
        return 'Grade must be between 0 and 100';
      }
    } catch (e) {
      return 'Invalid numeric input';
    }
    return ''; // No validation error
  }

  double calculateNeededGrade(
    double average,
    double gradeWanted,
    double remainingWeight,
  ) {
    if (remainingWeight == 0) {
      return 0;
    } else {
      return (gradeWanted - (1 - (remainingWeight / 100)) * average) /
          (remainingWeight / 100);
    }
  }

  double updateCurrentGrade(List<Deliverable> deliverableList) {
    double newGrade = 0;
    double weightSum = 0;
    for (int i = 0; i < deliverableList.length; i++) {
      if (deliverableList[i].grade != null) {
        newGrade += (deliverableList[i].grade! * deliverableList[i].weight);
        weightSum += deliverableList[i].weight;
      }
    }
    newGrade /= weightSum;
    return newGrade;
  }

  double calculateRemainingWeight(List<Deliverable> deliverableList) {
    double remainingWeight = 100;
    for (int i = 0; i < deliverableList.length; i++) {
      if (deliverableList[i].grade != null) {
        remainingWeight -= deliverableList[i].weight;
      }
    }
    return remainingWeight;
  }

  @override
  void initState() {
    average = widget.course.currentGrade?.toDouble() ?? 0;
    gradeWanted = widget.course.gradeWanted?.toDouble() ?? 100;
    gradeNeeded = widget.course.gradeNeeded?.toDouble() ?? 100;
    deliverableController = DeliverableController(course: widget.course);
    courseController = CourseController();
    Future.delayed(Duration.zero, () async {
      var dList = await deliverableController.listDeliverables();
      setState(() {
        deliverablesList = dList;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // ignore: prefer_function_declarations_over_variables
    final showBottomModal = (
      Deliverable deliverable,
      BuildContext context,
    ) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
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
                            Text(
                              deliverable.name,
                              style: const TextStyle(fontSize: 20),
                            ),
                            const SizedBox(height: 10),
                            TextField(
                              controller: _gradeController,
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
                                labelText: 'Grade (%)',
                                hintText: 'Enter a value between 0 and 100',
                                errorText: gradeErrorText,
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
                                      DateFormat.MMMd()
                                          .add_jm()
                                          .format(deliverable.due),
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
                                    String errorText = _validateGrade();
                                    if (errorText.isEmpty) {
                                      Deliverable newDeliverable = Deliverable(
                                        id: deliverable.id,
                                        name: deliverable.name,
                                        due: deliverable.due,
                                        weight: deliverable.weight,
                                        done: true,
                                        grade: int.parse(_gradeController.text)
                                            .toDouble(),
                                      );
                                      deliverableController
                                          .updateDeliverable(newDeliverable);

                                      Future.delayed(Duration.zero, () async {
                                        var dList = await deliverableController
                                            .listDeliverables();
                                        var newAverage =
                                            updateCurrentGrade(dList);

                                        var remainingWeight =
                                            calculateRemainingWeight(dList);

                                        var newGradeNeeded =
                                            calculateNeededGrade(
                                          newAverage,
                                          gradeWanted,
                                          remainingWeight,
                                        );

                                        var newCourse = Course(
                                          id: widget.course.id,
                                          name: widget.course.name,
                                          start: widget.course.start,
                                          end: widget.course.end,
                                          color: widget.course.color,
                                          questions: widget.course.questions,
                                          currentGrade: newAverage,
                                          gradeNeeded: newGradeNeeded,
                                          gradeWanted: gradeWanted,
                                        );

                                        await courseController
                                            .updateCourse(newCourse);
                                        super.setState(() {
                                          deliverablesList = dList;
                                          average = newAverage;
                                          gradeNeeded = newGradeNeeded;
                                        });
                                      });

                                      Navigator.of(context).pop();
                                    } else {
                                      setState(() {
                                        gradeErrorText = errorText;
                                      });
                                    }
                                  },
                                  child: const Text(
                                    style: TextStyle(fontSize: 15),
                                    'Save Grade',
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
                            "${average.round()}",
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
                            '${gradeNeeded.round()}',
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
                                  Future.delayed(
                                    Duration.zero,
                                    () async {
                                      var dList = await deliverableController
                                          .listDeliverables();
                                      var newAverage =
                                          updateCurrentGrade(dList);

                                      var remainingWeight =
                                          calculateRemainingWeight(dList);

                                      var newGradeNeeded = calculateNeededGrade(
                                        newAverage,
                                        gradeWanted,
                                        remainingWeight,
                                      );

                                      var newCourse = Course(
                                        id: widget.course.id,
                                        name: widget.course.name,
                                        start: widget.course.start,
                                        end: widget.course.end,
                                        color: widget.course.color,
                                        questions: widget.course.questions,
                                        currentGrade: newAverage,
                                        gradeNeeded: newGradeNeeded,
                                        gradeWanted: gradeWanted,
                                      );

                                      await courseController
                                          .updateCourse(newCourse);
                                      super.setState(() {
                                        deliverablesList = dList;
                                        average = newAverage;
                                        gradeNeeded = newGradeNeeded;
                                      });
                                    },
                                  );
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
                    SingleChildScrollView(
                      child: Column(
                        children: deliverablesList
                            .map(
                              (deliverable) => DeliverablesCard(
                                name: deliverable.name,
                                color: widget.color,
                                weight: deliverable.weight,
                                grade: deliverable.grade,
                                dueDate: deliverable.due,
                                dueTime: null,
                                padding: false,
                                onTap: () => showBottomModal(
                                  deliverable,
                                  context,
                                ),
                              ),
                            )
                            .toList(),
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
