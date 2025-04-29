import 'package:flutter/material.dart';

class SettingsEntity {
  final bool isDarkMode;
  final double fontSize;
  final Color primaryColor;
  final String language;
  final bool biometricEnabled;

  SettingsEntity({
    this.isDarkMode = false,
    this.fontSize = 1.0,
    this.primaryColor = const Color(0xFF3949AB), // Indigo 700
    this.language = 'es',
    this.biometricEnabled = false,
  });

  SettingsEntity copyWith({
    bool? isDarkMode,
    double? fontSize,
    Color? primaryColor,
    String? language,
    bool? biometricEnabled,
  }) {
    return SettingsEntity(
      isDarkMode: isDarkMode ?? this.isDarkMode,
      fontSize: fontSize ?? this.fontSize,
      primaryColor: primaryColor ?? this.primaryColor,
      language: language ?? this.language,
      biometricEnabled: biometricEnabled ?? this.biometricEnabled,
    );
  }
}
