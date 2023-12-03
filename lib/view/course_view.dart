import 'package:flutter/material.dart';

import './components/app_bar.dart';
import './components/nav_drawer.dart';

class CourseView extends StatelessWidget {
  final String name;
  final Color color;
  const CourseView({super.key, required this.name, required this.color});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const NavDrawer(),
      appBar: const CustomAppBar(),
      body: Center(
        child: Text('CourseView $name'),
      ),
    );
  }
}
