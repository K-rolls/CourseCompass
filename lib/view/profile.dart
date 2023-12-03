import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import './components/app_bar.dart';
import './components/nav_drawer.dart';
import './components/course_card.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const NavDrawer(),
      appBar: const CustomAppBar(),
      floatingActionButton: FloatingActionButton.extended(
        isExtended: true,
        onPressed: () => {},
        tooltip: 'Add a Course',
        icon: const Icon(Symbols.add),
        label: const Text(
          'New',
          style: TextStyle(fontSize: 15),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Symbols.account_circle,
                    weight: 250,
                    size: 140,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ],
              ),
              const Divider(
                indent: 16,
                endIndent: 16,
              ),
              Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const CourseCard(
                    name: 'Course 1',
                    color: Colors.blue, // Change color to blue
                  ),
                  const CourseCard(
                    name: 'Course 2',
                    color: Colors.teal, // Change color to teal
                  ),
                  const CourseCard(
                    name: 'Course 3',
                    color: Colors.amber, // Change color to amber
                  ),
                  const CourseCard(
                    name: 'Course 4',
                    color: Colors.purple, // Change color to purple
                  ),
                  const CourseCard(
                    name: 'Course 5',
                    color: Colors.cyan, // Change color to cyan
                  ),
                  const CourseCard(
                    name: 'Course 6',
                    color: Colors.brown, // Change color to brown
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        await FirebaseAuth.instance.signOut();
                        // ignore: use_build_context_synchronously
                        Navigator.of(context).pushNamed("/auth_gate");
                      },
                      icon: Icon(
                        color: Theme.of(context).colorScheme.secondary,
                        Symbols.logout_rounded,
                      ),
                      label: const Text('Logout'),
                      style: ElevatedButton.styleFrom(
                        side: BorderSide(
                          width: 2,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
