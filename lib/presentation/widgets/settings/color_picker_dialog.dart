import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class ColorPickerDialog extends StatelessWidget {
  const ColorPickerDialog({
    super.key,
    required this.colors,
    required this.selectedColor,
    required this.onColorSelected,
  });

  final List<Color> colors;
  final Color selectedColor;
  final Function(Color) onColorSelected;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(context.tr('settings.choose_color')),
      content: SizedBox(
        width: double.maxFinite,
        child: GridView.builder(
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 15,
            mainAxisSpacing: 15,
          ),
          itemCount: colors.length,
          itemBuilder: (context, index) {
            final color = colors[index];
            final isSelected = selectedColor == color;

            return GestureDetector(
              onTap: () {
                onColorSelected(color);
                Navigator.of(context).pop();
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? Colors.white : Colors.transparent,
                    width: 3,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: color.withAlpha(102),
                      blurRadius: isSelected ? 8 : 0,
                      spreadRadius: isSelected ? 2 : 0,
                    ),
                  ],
                ),
                child:
                    isSelected
                        ? const Icon(Icons.check, color: Colors.white)
                        : null,
              ),
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(context.tr('common.cancel')),
        ),
      ],
    );
  }
}
