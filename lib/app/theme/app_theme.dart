import 'package:flutter/material.dart';

const fontFamily = 'Inter';

final appTheme = ThemeData(
  useMaterial3: true,
  colorScheme: colorScheme,
  fontFamily: fontFamily,
  textTheme: textTheme,
);

// TODO
final colorScheme = ColorScheme.light(
  primary: const Color(0xFF1228B3),
  secondary: const Color(0xFFEEF1FF),
  tertiary: const Color(0xFFF6F7FA),
  onSurface: const Color(0xFF17213A),
  onSurfaceVariant: const Color(0xFF59677D),
);

final textTheme = const TextTheme(
  // TODO
).apply(fontFamily: fontFamily);