import 'package:flutter/material.dart';
import 'package:rescue_now_app/theme/colors.dart';

@immutable
class AppTheme {
  static const colors = AppColors();

  const AppTheme._();

  static ThemeData define() {
    return ThemeData(
      fontFamily: "Roboto",
    );
  }
}