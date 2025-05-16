import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nexust/core/enums/language.dart';

Settings settingsFromJson(String str) => Settings.fromJson(json.decode(str));
String settingsToJson(Settings data) => json.encode(data.toJson());

class Settings {
  final bool isDarkMode;
  final Color primaryColor;
  final double fontSize;
  final Language language;
  final bool biometricEnabled;

  Settings({
    this.isDarkMode = false,
    this.primaryColor = const Color(0xFF3949AB),
    this.fontSize = 1.0,
    this.language = Language.spanish,
    this.biometricEnabled = false,
  });

  factory Settings.fromJson(Map<String, dynamic> json) => Settings(
    isDarkMode: json['isDarkMode'] ?? false,
    primaryColor: Color(json['primaryColor'] ?? 0xFF3949AB),
    fontSize: (json['fontSize'] ?? 1.0).toDouble(),
    language: Language.values[json['language'] ?? 0],
    biometricEnabled: json['biometricEnabled'] ?? false,
  );

  Map<String, dynamic> toJson() => {
    'isDarkMode': isDarkMode,
    'primaryColor': primaryColor.toARGB32(),
    'fontSize': fontSize,
    'language': language.index,
    'biometricEnabled': biometricEnabled,
  };

  Settings copyWith({
    bool? isDarkMode,
    Color? primaryColor,
    double? fontSize,
    Language? language,
    bool? biometricEnabled,
  }) {
    return Settings(
      isDarkMode: isDarkMode ?? this.isDarkMode,
      primaryColor: primaryColor ?? this.primaryColor,
      fontSize: fontSize ?? this.fontSize,
      language: language ?? this.language,
      biometricEnabled: biometricEnabled ?? this.biometricEnabled,
    );
  }
}
