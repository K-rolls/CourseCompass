import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import './theme.dart';
import './view/home.dart';
import './view/grades.dart';
import './view/profile.dart';
import './view/auth_gate.dart';
import './firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const Color color = Colors.blueGrey;

  @override
  Widget build(BuildContext context) {
    final themeHelper = ThemeHelper(
      color: color,
    );
    return MaterialApp(
      title: 'My Course Compass',
      debugShowCheckedModeBanner: false,
      theme: themeHelper.getLightTheme(),
      darkTheme: themeHelper.getDarkTheme(),
      initialRoute: '/',
      routes: {
        '/': (context) => const AuthGateView(),
        '/home': (context) => const HomeView(),
        '/grades': (context) => const GradesView(),
        '/profile': (context) => const ProfileView(),
        '/auth_gate': (context) => const AuthGateView(),
      },
    );
  }
}
