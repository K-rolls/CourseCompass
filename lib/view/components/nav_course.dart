import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

class NavCourse extends NavigationDrawerDestination {
  final Color color;
  final String name;

  const NavCourse({
    super.key,
    required this.color,
    required this.name,
    required super.icon,
    required super.label,
  });

  @override
  Widget build(BuildContext context) {
    return NavigationDrawerDestination(
      icon: Icon(
        Symbols.circle,
        color: color,
        size: 25,
      ),
      selectedIcon: Icon(
        Icons.outbound,
        color: color,
        size: 25,
      ),
      label: Text(
        name,
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSurface,
          fontWeight: FontWeight.normal,
        ),
      ),
    );
  }
}
