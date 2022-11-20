import 'package:flutter/material.dart';
import 'package:radio_r159000/presentation/theme/extensions.dart';

final colorScheme = ColorScheme.fromSeed(
    seedColor: const Color(0xff16CE12),
);

final appTheme = ThemeData(
  colorScheme: colorScheme,
  extensions: const [
    ExtraColors(),
  ],
);
