import 'package:client/core/theme/app_pallate.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static OutlineInputBorder _border(Color color) => OutlineInputBorder(
    borderSide: BorderSide(color: color, width: 3),
    borderRadius: BorderRadius.circular(10),
  );
  static final darkThemeMode = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: Pallete.backgroundColor,
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: const EdgeInsets.all(27),
      focusedBorder: _border(Pallete.gradient2),
      enabledBorder: _border(Pallete.borderColor),
      disabledBorder: _border(Pallete.gradient2),
      focusedErrorBorder: _border(Pallete.gradient2),
      outlineBorder: const BorderSide(color: Pallete.gradient2, width: 3),
      errorBorder: _border(Pallete.errorColor),
    ),
    bottomNavigationBarTheme:const BottomNavigationBarThemeData(
      backgroundColor: Pallete.backgroundColor,
    ),
  );
}
