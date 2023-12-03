import 'package:flutter/material.dart';

import './components/app_bar.dart';
import './components/nav_drawer.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      drawer: NavDrawer(),
      appBar: CustomAppBar(),
      body: Center(
        child: Text('ProfileView'),
      ),
    );
  }
}
