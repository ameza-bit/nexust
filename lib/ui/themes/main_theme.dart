import 'package:flutter/material.dart';
import 'package:nexust/ui/themes/neutral_theme.dart';

class MainTheme {
  static ThemeData get lightTheme => ThemeData(
    scaffoldBackgroundColor: NeutralTheme.offWhite,
    primaryColor: Colors.indigo.shade700,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      elevation: 0,
    ),
  );

  static ThemeData get darkTheme => ThemeData(
    scaffoldBackgroundColor: NeutralTheme.richBlack,
    primaryColor: Colors.indigo.shade700,
    brightness: Brightness.dark,
    appBarTheme: AppBarTheme(
      backgroundColor: NeutralTheme.oilBlack,
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    cardColor: NeutralTheme.blackOpacity,
  );
}
