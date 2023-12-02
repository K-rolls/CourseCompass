import 'package:flutter/material.dart';

import './components/app_bar.dart';
import './components/nav_drawer.dart';
import './components/grades_view_card.dart';

class GradesView extends StatelessWidget {
  const GradesView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      drawer: NavDrawer(),
      appBar: CustomAppBar(),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // TODO: Update this to streambuilder
            GradesCard(
              name: 'Course 1',
              color: Colors.blue, // Change color to blue
            ),
            GradesCard(
              name: 'Course 2',
              color: Colors.teal, // Change color to teal
            ),
            GradesCard(
              name: 'Course 3',
              color: Colors.amber, // Change color to amber
            ),
            GradesCard(
              name: 'Course 4',
              color: Colors.purple, // Change color to purple
            ),
            GradesCard(
              name: 'Course 5',
              color: Colors.cyan, // Change color to cyan
            ),
            GradesCard(
              name: 'Course 6',
              color: Colors.brown, // Change color to brown
            ),
          ],
        ),
      ),
    );
  }
}
