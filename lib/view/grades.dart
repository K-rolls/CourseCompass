import 'package:flutter/material.dart';

import './components/app_bar.dart';
import './components/nav_drawer.dart';
import './components/grades_view_card.dart';
import '../controller/course_controller.dart';
import '../model/course.dart';

class GradesView extends StatefulWidget {
  const GradesView({super.key});

  @override
  GradesViewState createState() => GradesViewState();
}

class GradesViewState extends State<GradesView> {
  final CourseController _courseController = CourseController();
  List<Course> courses = [];
  bool loaded = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      await _fetchCourseData();
    });
    Future.delayed(Duration.zero, () async {
      await _fetchCourseData().then((_) {
        super.setState(() {
          loaded = true;
        });
      });
    });
  }

  Future<void> _fetchCourseData() async {
    var coursesWaited = await _courseController.listCourses();
    setState(() {
      courses = coursesWaited;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!loaded) {
      return const Scaffold(
        appBar: CustomAppBar(),
        drawer: NavDrawer(),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return Scaffold(
        drawer: const NavDrawer(),
        appBar: const CustomAppBar(),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: courses
                .map(
                  (course) => GradesCard(
                    name: course.name,
                    course: course,
                    color: course.color ?? Colors.blueGrey,
                  ),
                )
                .toList(),
          ),
        ),
      );
    }
  }
}
