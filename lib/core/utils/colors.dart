import 'package:flutter/material.dart';

class AppColors {
  static const Color charcoal = Color(0xFF424B54);
  static const Color gray = Color(0xFF93A8AC);
  static const Color white = Color(0xFFFFFFFF);
  static const Color orchidPink = Color(0xFFE2B4BD);
  static const Color roseTaupe = Color(0xFF9B6A6C);
  static const Color primary = Color(0xFF5D76A9);

  static MaterialColor primarySwatch = MaterialColor(
    primary.value,
    <int, Color>{
      50: primary.withOpacity(0.1),
      100: primary.withOpacity(0.2),
      200: primary.withOpacity(0.3),
      300: primary.withOpacity(0.4),
      400: primary.withOpacity(0.5),
      500: primary,
      600: primary.withOpacity(0.7),
      700: primary.withOpacity(0.8),
      800: primary.withOpacity(0.9),
      900: primary.withOpacity(1.0),
    },
  );
}
