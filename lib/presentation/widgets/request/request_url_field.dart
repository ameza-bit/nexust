import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nexust/core/extensions/theme_extensions.dart';
import 'package:nexust/core/font_awesome_flutter/lib/font_awesome_flutter.dart';

class RequestUrlField extends StatefulWidget {
  final TextEditingController controller;
  final Function(String)? onSubmitted;
  final Function(String)? onChanged;

  const RequestUrlField({
    super.key,
    required this.controller,
    this.onSubmitted,
    this.onChanged,
  });

  @override
  State<RequestUrlField> createState() => _RequestUrlFieldState();
}

class _RequestUrlFieldState extends State<RequestUrlField> {
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;
  bool _showClearButton = false;
  // Usamos esta bandera para evitar ciclos infinitos cuando el controller
  // se actualiza desde el exterior
  final bool _isInternalChange = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
    widget.controller.addListener(_onTextChanged);
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  void _onTextChanged() {
    setState(() {
      _showClearButton = widget.controller.text.isNotEmpty;
    });

    // Solo notificar cambios que vienen del usuario, no los que vienen
    // desde la actualización externa del controller
    if (!_isInternalChange && widget.onChanged != null) {
      widget.onChanged!(widget.controller.text);
    }
  }

  void _clearText() {
    widget.controller.clear();
    _focusNode.requestFocus();
    if (widget.onChanged != null) {
      widget.onChanged!('');
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    widget.controller.removeListener(_onTextChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: isDark ? Colors.black12 : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color:
              _isFocused
                  ? theme.primaryColor
                  : isDark
                  ? Colors.grey.shade800
                  : Colors.grey.shade300,
          width: _isFocused ? 1.5 : 1,
        ),
      ),
      child: Row(
        children: [
          // Icono de URL
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Icon(
              FontAwesomeIcons.lightGlobe,
              size: context.scaleIcon(16),
              color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
            ),
          ),

          // Campo de texto
          Expanded(
            child: TextField(
              controller: widget.controller,
              focusNode: _focusNode,
              onSubmitted: widget.onSubmitted,
              style: TextStyle(fontSize: context.scaleText(14)),
              textAlignVertical: TextAlignVertical.center,
              decoration: InputDecoration(
                hintText: 'https://api.example.com/endpoint',
                hintStyle: TextStyle(
                  color: isDark ? Colors.grey.shade600 : Colors.grey.shade400,
                  fontSize: context.scaleText(14),
                ),
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
              ),
              keyboardType: TextInputType.url,
              autocorrect: false,
              enableSuggestions: false,
              inputFormatters: [
                FilteringTextInputFormatter.deny(RegExp(r"\s")),
              ],
            ),
          ),

          // Botón de limpiar
          if (_showClearButton)
            IconButton(
              icon: Icon(
                Icons.clear,
                size: context.scaleIcon(16),
                color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
              ),
              onPressed: _clearText,
              splashRadius: 16,
              constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
              padding: EdgeInsets.zero,
            ),
        ],
      ),
    );
  }
}
