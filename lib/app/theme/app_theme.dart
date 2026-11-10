import 'package:flutter/material.dart';

const fontFamily = 'Inter';

final appTheme = ThemeData(
  useMaterial3: true,
  colorScheme: colorScheme,
  fontFamily: fontFamily,
  textTheme: textTheme,
);

// TODO
final colorScheme = ColorScheme.fromSeed(
  seedColor: const Color(0xFF1228B3)
);

final textTheme = const TextTheme(
  // TODO
).apply(fontFamily: fontFamily);