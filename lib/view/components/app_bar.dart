import 'package:material_symbols_icons/symbols.dart';
import "package:flutter/material.dart";

import '../home.dart';
import '../profile.dart';
import '../../custom_icons.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  static const int _transitionTime = 250;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
      leading: IconButton(
        tooltip: "Open navigation menu",
        iconSize: 30,
        icon: Icon(
          Symbols.menu,
          weight: 470,
          color: Theme.of(context).colorScheme.secondary,
        ),
        onPressed: () {
          Scaffold.of(context).openDrawer();
        },
      ),
      flexibleSpace: Container(
        alignment: Alignment.bottomCenter,
        padding: const EdgeInsets.only(bottom: 3),
        child: IconButton(
          tooltip: "Go to home page",
          iconSize: 35,
          icon: Icon(
            CustomIcons.mycoursecompass,
            color: Theme.of(context).colorScheme.secondary,
          ),
          onPressed: () {
            Navigator.pushReplacementNamed(
              context,
              '/home',
              arguments: PageRouteBuilder(
                transitionDuration:
                    const Duration(milliseconds: _transitionTime),
                pageBuilder: (_, __, ___) => const HomeView(),
                transitionsBuilder: (_, animation, __, child) {
                  return FadeTransition(
                    opacity: animation,
                    child: child,
                  );
                },
              ),
            );
          },
        ),
      ),
      actions: [
        IconButton(
          tooltip: "Go to profile page",
          iconSize: 30,
          icon: Icon(
            Symbols.account_circle,
            weight: 470,
            color: Theme.of(context).colorScheme.secondary,
          ),
          onPressed: () {
            Navigator.pushReplacementNamed(
              context,
              '/profile',
              arguments: PageRouteBuilder(
                transitionDuration:
                    const Duration(milliseconds: _transitionTime),
                pageBuilder: (_, __, ___) => const ProfileView(),
                transitionsBuilder: (_, animation, __, child) {
                  return FadeTransition(
                    opacity: animation,
                    child: child,
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }
}
