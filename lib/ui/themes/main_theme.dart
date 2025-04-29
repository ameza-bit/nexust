import 'package:flutter/material.dart';
import 'package:nexust/ui/themes/neutral_theme.dart';

class MainTheme {
  static ThemeData get lightTheme => ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: NeutralTheme.offWhite,
    primaryColor: Colors.indigo.shade700,
    colorScheme: ColorScheme.light(
      primary: Colors.indigo.shade700,
      secondary: Colors.indigo.shade400,
      surface: NeutralTheme.offWhite,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      elevation: 0,
    ),
    cardColor: Colors.white,
    dividerColor: Colors.grey.shade200,
    iconTheme: IconThemeData(color: Colors.grey.shade700),
  );

  static ThemeData get darkTheme => ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: NeutralTheme.richBlack,
    primaryColor: Colors.indigo.shade500,
    colorScheme: ColorScheme.dark(
      primary: Colors.indigo.shade500,
      secondary: Colors.indigo.shade300,
      surface: NeutralTheme.oilBlack,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: NeutralTheme.oilBlack,
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    cardColor: NeutralTheme.blackOpacity,
    dividerColor: Colors.grey.shade800,
    iconTheme: IconThemeData(color: Colors.grey.shade300),
  );
}
