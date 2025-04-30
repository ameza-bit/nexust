import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexust/core/font_awesome_flutter/lib/font_awesome_flutter.dart';
import 'package:nexust/presentation/blocs/settings/settings_cubit.dart';
import 'package:nexust/presentation/blocs/settings/settings_state.dart';
import 'package:nexust/presentation/widgets/settings/settings_section.dart';
import 'package:nexust/presentation/widgets/settings/settings_item.dart';
import 'package:nexust/presentation/widgets/settings/color_picker_dialog.dart';

class SettingsScreen extends StatelessWidget {
  static const String routeName = "settings";
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        final isDarkMode = state.settings.isDarkMode;
        final primaryColor = state.settings.primaryColor;
        final fontSize = state.settings.fontSize;
        final language =
            state.settings.language == 'es' ? 'Español' : 'English';
        final biometricEnabled = state.settings.biometricEnabled;

        final availableColors = [
          Colors.indigo.shade700,
          Colors.blue.shade700,
          Colors.teal.shade700,
          Colors.green.shade700,
          Colors.amber.shade700,
          Colors.orange.shade700,
          Colors.red.shade700,
          Colors.purple.shade700,
        ];

        final backgroundColor = isDarkMode ? Colors.black : Colors.white;
        final foregroundColor = isDarkMode ? Colors.white : Colors.black;

        return Scaffold(
          appBar: AppBar(
            title: Text(
              context.tr('navigation.settings'),
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            elevation: 0,
            backgroundColor: backgroundColor,
            foregroundColor: foregroundColor,
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Tema
                    SettingsSection(
                      title: context.tr('settings.appearance'),
                      children: [
                        SettingsItem(
                          icon: FontAwesomeIcons.lightMoonStars,
                          title: context.tr('settings.dark_mode'),
                          iconColor: primaryColor,
                          trailing: Switch(
                            value: isDarkMode,
                            activeColor: primaryColor,
                            onChanged: (value) {
                              context.read<SettingsCubit>().toggleDarkMode(
                                value,
                              );
                            },
                          ),
                        ),
                        SettingsItem(
                          icon: FontAwesomeIcons.lightPalette,
                          title: context.tr('settings.primary_color'),
                          iconColor: primaryColor,
                          trailing: GestureDetector(
                            onTap:
                                () => _showColorPicker(
                                  context,
                                  primaryColor,
                                  availableColors,
                                ),
                            child: Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                color: primaryColor,
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                            ),
                          ),
                        ),
                        SettingsItem(
                          icon: FontAwesomeIcons.lightTextSize,
                          title: context.tr('settings.font_size'),
                          iconColor: primaryColor,
                          trailing: SizedBox(
                            width: 150,
                            child: Slider(
                              value: fontSize,
                              min: 0.8,
                              max: 1.2,
                              divisions: 4,
                              label: _getFontSizeLabel(context, fontSize),
                              activeColor: primaryColor,
                              onChanged: (value) {
                                context.read<SettingsCubit>().updateFontSize(
                                  value,
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Idioma
                    SettingsSection(
                      title: context.tr('settings.language'),
                      children: [
                        SettingsItem(
                          icon: FontAwesomeIcons.lightGlobe,
                          title: context.tr('settings.app_language'),
                          iconColor: primaryColor,
                          trailing: DropdownButton<String>(
                            value: language,
                            icon: const Icon(Icons.arrow_drop_down),
                            elevation: 16,
                            style: TextStyle(
                              color: foregroundColor,
                              fontSize: 16,
                            ),
                            underline: Container(
                              height: 2,
                              color: primaryColor,
                            ),
                            onChanged: (String? value) {
                              if (value != null) {
                                final langCode =
                                    value == 'Español' ? 'es' : 'en';
                                context.read<SettingsCubit>().updateLanguage(
                                  langCode,
                                );
                                context.setLocale(Locale(langCode));
                              }
                            },
                            items:
                                [
                                  'Español',
                                  'English',
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Seguridad
                    SettingsSection(
                      title: context.tr('settings.security'),
                      children: [
                        SettingsItem(
                          icon: FontAwesomeIcons.lightFingerprint,
                          title: context.tr('settings.biometric_auth'),
                          subtitle: context.tr('settings.biometric_auth_desc'),
                          iconColor: primaryColor,
                          trailing: Switch(
                            value: biometricEnabled,
                            activeColor: primaryColor,
                            onChanged: (value) {
                              context.read<SettingsCubit>().toggleBiometricAuth(
                                value,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  String _getFontSizeLabel(BuildContext context, double fontSize) {
    if (fontSize <= 0.8) return context.tr('settings.font_size_small');
    if (fontSize <= 0.9) return context.tr('settings.font_size_medium_small');
    if (fontSize <= 1.1) return context.tr('settings.font_size_medium');
    if (fontSize <= 1.2) return context.tr('settings.font_size_medium_large');
    return context.tr('settings.font_size_large');
  }

  void _showColorPicker(
    BuildContext context,
    Color selectedColor,
    List<Color> availableColors,
  ) {
    showDialog(
      context: context,
      builder:
          (context) => ColorPickerDialog(
            colors: availableColors,
            selectedColor: selectedColor,
            onColorSelected: (color) {
              context.read<SettingsCubit>().updatePrimaryColor(color);
            },
          ),
    );
  }
}
