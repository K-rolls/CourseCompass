import 'package:flutter/material.dart';

import './components/app_bar.dart';
import './components/nav_drawer.dart';

class CourseArchiveView extends StatelessWidget {
  const CourseArchiveView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      drawer: NavDrawer(),
      appBar: CustomAppBar(),
      body: Center(
        child: Text('CourseArchiveView'),
      ),
    );
  }
}
