import 'package:flutter/material.dart';

class ThemeHelper {
  final Color color;

  ThemeHelper({
    required this.color,
  });

  ThemeData getLightTheme() {
    return ThemeData.light(
      useMaterial3: true,
    ).copyWith(
      colorScheme: ColorScheme.fromSeed(
        seedColor: color,
        brightness: Brightness.light,
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        showDragHandle: true,
      ),
    );
  }

  ThemeData getDarkTheme() {
    return ThemeData.dark(
      useMaterial3: true,
    ).copyWith(
      colorScheme: ColorScheme.fromSeed(
        seedColor: color,
        brightness: Brightness.dark,
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        showDragHandle: true,
      ),
    );
  }
}
