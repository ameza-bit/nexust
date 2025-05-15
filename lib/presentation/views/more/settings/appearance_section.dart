import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:nexust/core/font_awesome_flutter/lib/font_awesome_flutter.dart';
import 'package:nexust/presentation/views/more/settings/color_picker_dialog.dart';
import 'package:nexust/presentation/widgets/common/section_card.dart';
import 'package:nexust/presentation/widgets/common/section_item.dart';

class AppearanceSection extends StatefulWidget {
  const AppearanceSection({super.key});

  @override
  State<AppearanceSection> createState() => _AppearanceSectionState();
}

class _AppearanceSectionState extends State<AppearanceSection> {
  late double _currentFontSize;

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
              // context.read<SettingsCubit>().updatePrimaryColor(color);
            },
          ),
    );
  }

  String _getFontSizeLabel(BuildContext context, double fontSize) {
    if (fontSize <= 0.8) return context.tr('settings.font_size_small');
    if (fontSize <= 0.9) return context.tr('settings.font_size_medium_small');
    if (fontSize <= 1.1) return context.tr('settings.font_size_medium');
    if (fontSize <= 1.2) return context.tr('settings.font_size_medium_large');
    return context.tr('settings.font_size_large');
  }

  @override
  void initState() {
    super.initState();
    // Initialize the slider to the saved font size
    _currentFontSize = 1.0;
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = true;
    final primaryColor = Colors.red.shade700;

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

    return SectionCard(
      title: context.tr('settings.appearance'),
      children: [
        SectionItem(
          icon: FontAwesomeIcons.lightMoonStars,
          title: context.tr('settings.dark_mode'),
          iconColor: primaryColor,
          trailing: Switch(
            value: isDarkMode,
            activeColor: primaryColor,
            onChanged: (value) {},
          ),
        ),
        SectionItem(
          icon: FontAwesomeIcons.lightPalette,
          title: context.tr('settings.primary_color'),
          iconColor: primaryColor,
          trailing: GestureDetector(
            onTap:
                () => _showColorPicker(context, primaryColor, availableColors),
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
        SectionItem(
          icon: FontAwesomeIcons.lightTextSize,
          title: context.tr('settings.font_size'),
          iconColor: primaryColor,
          trailing: SizedBox(
            width: 150,
            child: Slider(
              value: _currentFontSize,
              min: 0.8,
              max: 1.2,
              divisions: 4,
              label: _getFontSizeLabel(context, _currentFontSize),
              activeColor: primaryColor,
              onChanged: (value) => setState(() => _currentFontSize = value),
              onChangeEnd: (value) {
                // context.read<SettingsCubit>().updateFontSize(value);
              },
            ),
          ),
        ),
      ],
    );
  }
}
