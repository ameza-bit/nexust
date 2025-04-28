import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:nexust/core/font_awesome_flutter/lib/font_awesome_flutter.dart';
import 'package:nexust/ui/widgets/settings/settings_section.dart';
import 'package:nexust/ui/widgets/settings/settings_item.dart';
import 'package:nexust/ui/widgets/settings/color_picker_dialog.dart';

class SettingsScreen extends StatefulWidget {
  static const String routeName = "settings";
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isDarkMode = false;
  String _selectedLanguage = 'Español';
  bool _biometricEnabled = false;
  double _fontSize = 1.0; // Factor de escala, 1.0 = normal
  Color _primaryColor = Colors.indigo.shade700;

  // Lista de idiomas disponibles
  final List<String> _languages = [
    'Español',
    'English',
    'Français',
    'Português',
  ];

  // Lista de colores para elegir
  final List<Color> _availableColors = [
    Colors.indigo.shade700,
    Colors.blue.shade700,
    Colors.teal.shade700,
    Colors.green.shade700,
    Colors.amber.shade700,
    Colors.orange.shade700,
    Colors.red.shade700,
    Colors.purple.shade700,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.tr('navigation.settings'),
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
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
                      trailing: Switch(
                        value: _isDarkMode,
                        activeColor: _primaryColor,
                        onChanged: (value) {
                          setState(() {
                            _isDarkMode = value;
                          });
                          // Aquí iría la lógica para cambiar el tema
                        },
                      ),
                    ),
                    SettingsItem(
                      icon: FontAwesomeIcons.lightPalette,
                      title: context.tr('settings.primary_color'),
                      trailing: GestureDetector(
                        onTap: () => _showColorPicker(context),
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            color: _primaryColor,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                        ),
                      ),
                    ),
                    SettingsItem(
                      icon: FontAwesomeIcons.lightTextSize,
                      title: context.tr('settings.font_size'),
                      trailing: SizedBox(
                        width: 150,
                        child: Slider(
                          value: _fontSize,
                          min: 0.8,
                          max: 1.2,
                          divisions: 4,
                          label: _getFontSizeLabel(),
                          activeColor: _primaryColor,
                          onChanged: (value) {
                            setState(() {
                              _fontSize = value;
                            });
                            // Aquí iría la lógica para cambiar el tamaño de fuente
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
                      trailing: DropdownButton<String>(
                        value: _selectedLanguage,
                        icon: const Icon(Icons.arrow_drop_down),
                        elevation: 16,
                        style: TextStyle(color: Colors.black87, fontSize: 16),
                        underline: Container(height: 2, color: _primaryColor),
                        onChanged: (String? value) {
                          if (value != null) {
                            setState(() {
                              _selectedLanguage = value;
                            });
                            // Aquí iría la lógica para cambiar el idioma
                          }
                        },
                        items:
                            _languages.map<DropdownMenuItem<String>>((
                              String value,
                            ) {
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
                      trailing: Switch(
                        value: _biometricEnabled,
                        activeColor: _primaryColor,
                        onChanged: (value) {
                          setState(() {
                            _biometricEnabled = value;
                          });
                          // Aquí iría la lógica para habilitar/deshabilitar biométricos
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
  }

  String _getFontSizeLabel() {
    if (_fontSize <= 0.8) return context.tr('settings.font_size_small');
    if (_fontSize <= 0.9) return context.tr('settings.font_size_medium_small');
    if (_fontSize <= 1.0) return context.tr('settings.font_size_medium');
    if (_fontSize <= 1.1) return context.tr('settings.font_size_medium_large');
    return context.tr('settings.font_size_large');
  }

  void _showColorPicker(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => ColorPickerDialog(
            colors: _availableColors,
            selectedColor: _primaryColor,
            onColorSelected: (color) {
              setState(() {
                _primaryColor = color;
              });
              // Aquí iría la lógica para cambiar el color principal
            },
          ),
    );
  }
}
