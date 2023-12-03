import 'package:flutter/material.dart';

class CustomTextStyle {
  static EdgeInsets get defaultPadding => const EdgeInsets.only(
        top: 4.0,
        bottom: 4.0,
        left: 16.0,
        right: 16.0,
      );

  static const double mainFontSize = 24.0;

  static TextStyle get titleStyle {
    return const TextStyle(
      fontSize: mainFontSize,
      fontWeight: FontWeight.bold,
    );
  }

  static TextStyle get bodyStyle {
    return const TextStyle(
      fontSize: mainFontSize - 8.0,
    );
  }
}
