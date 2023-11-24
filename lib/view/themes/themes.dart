import "package:flutter/material.dart";
import 'color_schemes.g.dart';

final lightTheme = ThemeData(
  useMaterial3: true,
  colorScheme: lightColorScheme,
  primaryColor: lightColorScheme.primary,
  scaffoldBackgroundColor: lightColorScheme.background,
  appBarTheme: AppBarTheme(
    backgroundColor: lightColorScheme.onSecondary,
    iconTheme: IconThemeData(
      color: lightColorScheme.secondary,
    ),
  ),
  textTheme: TextTheme(
    displayLarge: TextStyle(
      color: lightColorScheme.onBackground,
      fontSize: 24,
      fontWeight: FontWeight.bold,
    ),
  ),
  bottomSheetTheme: BottomSheetThemeData(
    backgroundColor: lightColorScheme.secondary,
    surfaceTintColor: lightColorScheme.onSecondaryContainer,
    elevation: 10,
    modalElevation: 10,
    showDragHandle: true,
    dragHandleColor: lightColorScheme.onSecondary,
    dragHandleSize: const Size(50, 5),
  ),
);

final darkTheme = ThemeData(
  useMaterial3: true,
  colorScheme: darkColorScheme,
  primaryColor: darkColorScheme.primary,
  scaffoldBackgroundColor: darkColorScheme.background,
  appBarTheme: AppBarTheme(
    backgroundColor: darkColorScheme.onSecondary,
    actionsIconTheme: IconThemeData(
      color: darkColorScheme.secondary,
    ),
    iconTheme: IconThemeData(
      color: darkColorScheme.secondary,
    ),
  ),
  textTheme: TextTheme(
    displayLarge: TextStyle(
      color: darkColorScheme.onBackground,
      fontSize: 24,
      fontWeight: FontWeight.bold,
    ),
  ),
  bottomSheetTheme: BottomSheetThemeData(
    backgroundColor: darkColorScheme.secondary,
    surfaceTintColor: darkColorScheme.onSecondaryContainer,
    elevation: 10,
    modalElevation: 10,
    showDragHandle: true,
    dragHandleColor: darkColorScheme.onSecondary,
    dragHandleSize: const Size(50, 5),
  ),
);
