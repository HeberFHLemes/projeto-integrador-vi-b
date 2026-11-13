import 'package:flutter/material.dart';

const fontFamily = 'Inter';

final appTheme = ThemeData(
  useMaterial3: true,
  colorScheme: colorScheme,
  fontFamily: fontFamily,
  textTheme: textTheme,
  inputDecorationTheme: inputDecorationTheme,
);

final colorScheme = ColorScheme.light(
  primary: const Color(0xFF1228B3),
  secondary: const Color(0xFFEEF1FF),
  tertiary: const Color(0xFFF6F7FA),
  onPrimary: Colors.white,
  onSurface: const Color(0xFF17213A),
  onSurfaceVariant: const Color(0xFF59677D),
  error: const Color(0xFFA33339),
);

final textTheme = const TextTheme(
  displaySmall: TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w700,
  ),

  headlineSmall: TextStyle(
    fontSize: 26,
    fontWeight: FontWeight.w700,
  ),

  titleMedium: TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
  ),

  bodyMedium: TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
  ),

  labelLarge: TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w600,
  ),

  labelMedium: TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
  ),

  labelSmall: TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
  ),
).apply(
  fontFamily: fontFamily,
);

final inputDecorationTheme = InputDecorationTheme(
  floatingLabelBehavior: FloatingLabelBehavior.never,
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(
      color: colorScheme.onSurfaceVariant,
      width: 0.5,
    ),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(
      color: colorScheme.primary
    ),
  ),
);
