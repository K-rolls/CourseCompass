import 'package:course_compass/controller/course_controller.dart';
import 'package:course_compass/controller/schedule_controller.dart';
import 'package:course_compass/model/schedule.dart';
import 'package:flutter/material.dart';

import '../model/course.dart';
import './components/app_bar.dart';
import './components/nav_drawer.dart';

class AttendanceView extends StatefulWidget {
  final Schedule schedule;
  final String name;
  final Color color;
  final String courseName;

  const AttendanceView({
    super.key,
    required this.schedule,
    required this.name,
    required this.color,
    required this.courseName,
  });

  @override
  AttendanceState createState() => AttendanceState();
}

class AttendanceState extends State<AttendanceView> {
  bool? value;
  final CourseController _courseController = CourseController();
  late final ScheduleController _scheduleController;
  late final Schedule schedule;
  late final Course? course;
  String? classSummary;

  @override
  void initState() {
    super.initState();
    classSummary = widget.schedule.summary;
    value = widget.schedule.attended ?? false;
    Future.delayed(Duration.zero, () async {
      course = await _courseController.getCourseByName(
        courseName: widget.courseName,
      );
      _scheduleController = ScheduleController(
        course: course,
      );
    });
  }

  void _save() async {
    schedule = Schedule(
      id: widget.schedule.id,
      name: widget.name,
      dateTime: widget.schedule.dateTime,
      attended: value!,
      summary: classSummary ?? widget.schedule.summary,
    );
    _scheduleController.updateSchedule(schedule);
  }

  @override
  Widget build(BuildContext context) {
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
      child: Scaffold(
        drawer: const NavDrawer(),
        appBar: const CustomAppBar(),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Did you attend this class?",
                  style: TextStyle(
                    fontSize: 25,
                  ),
                ),
                Checkbox(
                  value: value,
                  onChanged: (bool? value) {
                    super.setState(() {
                      this.value = value!;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 400,
                  width: 400,
                  child: TextFormField(
                    maxLines: 20,
                    minLines: 12,
                    decoration: const InputDecoration(
                      alignLabelWithHint: true,
                      border: OutlineInputBorder(),
                      labelText: 'Enter Class Summary',
                    ),
                    initialValue: classSummary,
                    onChanged: (String value) {
                      setState(() {
                        classSummary = value;
                      });
                    },
                  ),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                _save();
                Navigator.pushNamed(context, '/home');
              },
              child: const Text('Save and Exit'),
            ),
          ],
        ),
      ),
    );
  }
}
