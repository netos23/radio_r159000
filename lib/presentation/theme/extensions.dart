import 'package:flutter/material.dart';

class ExtraColors extends ThemeExtension<ExtraColors> {
  final Color mainText;

  const ExtraColors({
    this.mainText = Colors.black,
  });

  @override
  ThemeExtension<ExtraColors> copyWith({
    Color? mainText,
  }) {
    return ExtraColors(
      mainText: mainText ?? this.mainText,
    );
  }

  @override
  ThemeExtension<ExtraColors> lerp(
      ThemeExtension<ExtraColors>? other, double t) {
    if (other is! ExtraColors) {
      return this;
    }
    return ExtraColors(
      mainText: Color.lerp(mainText, other.mainText, t) ?? mainText,
    );
  }
}
