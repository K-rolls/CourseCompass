import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';

import '../../custom_icons.dart';
import 'home.dart';

class AuthGateView extends StatelessWidget {
  const AuthGateView({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Scaffold(
            body: Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 100.0),
                child: SignInScreen(
                  providers: [
                    EmailAuthProvider(),
                  ],
                  headerBuilder: (context, constraints, shrinkOffset) {
                    return SizedBox(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(
                            size: 80,
                            CustomIcons.mycoursecompass,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                          Text(
                            'My Course Compass',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        }

        return const HomeView();
      },
    );
  }
}
