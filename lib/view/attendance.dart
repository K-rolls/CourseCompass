import 'package:flutter/material.dart';

import './components/app_bar.dart';
import './components/nav_drawer.dart';

class AttendanceView extends StatefulWidget {
  final String name;
  final Color color;

  const AttendanceView({
    super.key,
    required this.name,
    required this.color,
  });
  @override
  AttendanceState createState() => AttendanceState();
}

class AttendanceState extends State<AttendanceView> {
  bool? value = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  setState(
                    () {
                      this.value = value!;
                    },
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 400,
                width: 400,
                child: TextField(
                  maxLines: 20,
                  minLines: 12,
                  decoration: InputDecoration(
                    alignLabelWithHint: true,
                    border: OutlineInputBorder(),
                    labelText: 'Enter Class Summary',
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
