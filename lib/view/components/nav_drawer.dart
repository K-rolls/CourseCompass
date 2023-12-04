import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'dart:async';

import '../../controller/nav_drawer_controller.dart';
import '../../controller/course_controller.dart';
import '../../custom_icons.dart';
import '../../model/course.dart';
import '../course_view.dart';

class NavDrawer extends StatefulWidget {
  const NavDrawer({super.key});

  @override
  NavDrawerState createState() => NavDrawerState();
}

class NavDrawerState extends State<NavDrawer> {
  int? selectedIndex;
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      var currentRoute = ModalRoute.of(context)!.settings.name;
      if (currentRoute == null) {
        setState(() {
          selectedIndex = null;
        });
      } else {
        var selectedIndex = await NavDrawerController.routeToInt(currentRoute);
        setState(() {
          this.selectedIndex = selectedIndex;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final selectedTileColor = Theme.of(context).colorScheme.secondaryContainer;
    return Drawer(
      child: StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return ListView(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondaryContainer,
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.only(
                    left: 16.0,
                    right: 16.0,
                    top: 8.0,
                    bottom: 8.0,
                  ),
                  leading: Icon(
                    CustomIcons.mycoursecompass,
                    size: 40.0,
                    color: Theme.of(context).colorScheme.onSecondaryContainer,
                  ),
                  title: Text(
                    'My Course Compass',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSecondaryContainer,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 4.0),
              ListTile(
                leading: const Icon(
                  Symbols.home_rounded,
                ),
                title: const Text('Home'),
                selected: selectedIndex == 0,
                selectedTileColor: selectedTileColor,
                style: ListTileStyle.list,
                onTap: () {
                  super.setState(() {
                    selectedIndex = 0;
                  });
                  Navigator.of(context).pushNamed('/home');
                },
              ),
              ListTile(
                leading: const Icon(
                  Symbols.history_edu_rounded,
                ),
                selected: selectedIndex == 1,
                selectedTileColor: selectedTileColor,
                title: const Text('Grades'),
                onTap: () {
                  setState(() {
                    selectedIndex = 1;
                  });
                  Navigator.of(context).pushNamed('/grades');
                },
              ),
              ListTile(
                leading: const Icon(
                  Symbols.account_circle_rounded,
                ),
                selected: selectedIndex == 2,
                selectedTileColor: selectedTileColor,
                title: const Text('Profile'),
                onTap: () {
                  super.setState(() {
                    selectedIndex = 2;
                  });
                  Navigator.of(context).pushNamed('/profile');
                },
              ),
              const Divider(),
              StreamBuilder<List<Course>>(
                stream: CourseController().listCourses().asStream(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final courses = snapshot.data!;
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: courses.length,
                      itemBuilder: (context, index) {
                        final course = courses[index];
                        return ListTile(
                          leading: Icon(
                            Symbols.circle,
                            color: course.color ?? Colors.blueGrey,
                            size: 25,
                          ),
                          selected: selectedIndex == index + 3,
                          selectedTileColor: selectedTileColor,
                          title: Text(
                            course.name,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          onTap: () async {
                            super.setState(() {
                              selectedIndex = null;
                            });
                            await Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => CourseView(
                                  courseName: course.name,
                                ),
                              ),
                            );
                          },
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return const SizedBox(
                      height: 100,
                      width: 100,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                },
              ),
              const Divider(),
              ListTile(
                title: const Text(
                  'Add Course',
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
                leading: const Icon(
                  Symbols.add,
                  size: 25.0,
                ),
                onTap: () {
                  Navigator.of(context).pushNamed('/add_course');
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(
                  Symbols.logout_rounded,
                ),
                selected: selectedIndex == 999,
                selectedTileColor: selectedTileColor,
                title: const Text('Logout'),
                onTap: () async {
                  super.setState(() {
                    selectedIndex = 999;
                  });
                  await FirebaseAuth.instance.signOut().then((value) {
                    Navigator.of(context).pushNamed('/auth_gate');
                  });
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
