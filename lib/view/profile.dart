import 'package:course_compass/model/course.dart';
import 'package:course_compass/view/styles/text_style.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../controller/course_controller.dart';
import './components/app_bar.dart';
import './components/nav_drawer.dart';
import './components/course_card.dart';
import 'components/course_config_flow/general.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final CourseController _courseController = CourseController();
  List<Course>? courses;

  @override
  void initState() {
    super.initState();
    Future.delayed(
      Duration.zero,
      () async {
        List<Course>? tempCourses = await _courseController.listCourses();
        if (tempCourses.isEmpty) {
          tempCourses = null;
        }
        setState(() {
          courses = tempCourses;
        });
      },
    );
  }

  Future<Null> deleteCourse({required Course courseToBeDeleted}) async {
    await _courseController.deleteCourse(courseToBeDeleted);
    List<Course>? tempCourses = await _courseController.listCourses();
    if (tempCourses.isEmpty) {
      tempCourses = null;
    }
    setState(() {
      courses = tempCourses;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const NavDrawer(),
      appBar: const CustomAppBar(),
      floatingActionButton: FloatingActionButton(
        isExtended: true,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => const CourseConfigGeneral(),
            ),
          );
        },
        tooltip: 'Add a Course',
        child: const Icon(
          Symbols.add_rounded,
          size: 30,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Symbols.account_circle,
                  weight: 200,
                  size: 50,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  FirebaseAuth.instance.currentUser!.displayName == null
                      ? FirebaseAuth.instance.currentUser!.email!
                      : FirebaseAuth.instance.currentUser!.displayName!,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                    fontSize: CustomTextStyle.titleStyle.fontSize,
                  ),
                ),
              ],
            ),
            const Divider(
              endIndent: 16,
              indent: 16,
              thickness: 2,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 8, 0),
              child: Row(
                children: [
                  Text(
                    'Your Courses',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
            SingleChildScrollView(
              child: RawScrollbar(
                radius: const Radius.circular(8.0),
                thumbColor: Theme.of(context).colorScheme.onBackground,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: courses
                              ?.map(
                                (course) => CourseCard(
                                  name: course.name,
                                  color: course.color ?? Colors.blueGrey,
                                  onLongPress: () async {
                                    await showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text(
                                            'Delete Course?',
                                          ),
                                          content: const Text(
                                            'Do you want to delete this course?',
                                          ),
                                          actionsAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          actions: [
                                            TextButton(
                                              onPressed: () async {
                                                await deleteCourse(
                                                  courseToBeDeleted: course,
                                                ).then(
                                                  Navigator.of(context).pop,
                                                );
                                              },
                                              child: const Text('Yes'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text('No'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                ),
                              )
                              .toList() ??
                          [
                            const SizedBox(
                              height: 200,
                              width: 200,
                              child: Center(
                                child: SizedBox(
                                  height: 50,
                                  width: 50,
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                            ),
                          ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
