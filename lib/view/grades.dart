import './components/app_bar.dart';
import './components/nav_drawer.dart';
import 'package:flutter/material.dart';

class GradesView extends StatelessWidget {
  const GradesView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      drawer: NavDrawer(),
      appBar: CustomAppBar(),
      body: Center(
        child: Text('GradesView'),
      ),
    );
  }
}
