import 'package:flutter/material.dart';
import 'package:nexust/core/extensions/theme_extensions.dart';
import 'package:nexust/data/enums/method.dart';

class HttpMethodSelector extends StatefulWidget {
  final Method selectedMethod;
  final Function(Method) onMethodChanged;

  const HttpMethodSelector({
    super.key,
    required this.selectedMethod,
    required this.onMethodChanged,
  });

  @override
  State<HttpMethodSelector> createState() => _HttpMethodSelectorState();
}

class _HttpMethodSelectorState extends State<HttpMethodSelector> {
  late Method _selectedMethod;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _selectedMethod = widget.selectedMethod;
  }

  @override
  void didUpdateWidget(HttpMethodSelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedMethod != oldWidget.selectedMethod) {
      _selectedMethod = widget.selectedMethod;
    }
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
    });

    if (_isExpanded) {
      OverlayState? overlayState = Overlay.of(context);
      LayerLink layerLink = LayerLink();

      OverlayEntry overlayEntry = OverlayEntry(
        builder: (context) {
          return _MethodsOverlay(
            methods: Method.values,
            selectedMethod: _selectedMethod,
            onMethodSelected: (method) {
              _selectMethod(method);
              // overlayEntry.remove();
            },
            layerLink: layerLink,
          );
        },
      );

      // Añadir el overlay y cerrarlo al tocar fuera
      overlayState.insert(overlayEntry);

      // Autocierre después de un tiempo si no se selecciona nada
      Future.delayed(const Duration(seconds: 5), () {
        if (overlayEntry.mounted) {
          overlayEntry.remove();
          setState(() {
            _isExpanded = false;
          });
        }
      });
    }
  }

  void _selectMethod(Method method) {
    setState(() {
      _selectedMethod = method;
      _isExpanded = false;
    });
    widget.onMethodChanged(method);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          width: context.scaleText(90),
          decoration: BoxDecoration(
            color: isDark ? Colors.black12 : Colors.grey.shade50,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
            ),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: _toggleExpanded,
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Nombre del método
                    Text(
                      _selectedMethod.stringName,
                      style: TextStyle(
                        color: _selectedMethod.color,
                        fontWeight: FontWeight.bold,
                        fontSize: context.scaleText(14),
                      ),
                    ),

                    // Icono de flecha
                    Icon(
                      _isExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                      color:
                          isDark ? Colors.grey.shade400 : Colors.grey.shade700,
                      size: context.scaleIcon(20),
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

  @override
  void dispose() {
    super.dispose();
  }
}

// Widget overlay para mostrar los métodos disponibles
class _MethodsOverlay extends StatelessWidget {
  final List<Method> methods;
  final Method selectedMethod;
  final Function(Method) onMethodSelected;
  final LayerLink layerLink;

  const _MethodsOverlay({
    required this.methods,
    required this.selectedMethod,
    required this.onMethodSelected,
    required this.layerLink,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return CompositedTransformFollower(
      link: layerLink,
      showWhenUnlinked: false,
      offset: Offset(0, 40),
      child: Material(
        elevation: 8,
        borderRadius: BorderRadius.circular(8),
        color: isDark ? theme.cardColor : Colors.white,
        child: Container(
          width: 120,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
            ),
          ),
          child: ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            itemCount: methods.length,
            itemBuilder: (context, index) {
              final method = methods[index];
              final isSelected = method == selectedMethod;

              return Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => onMethodSelected(method),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color:
                          isSelected
                              ? method.color.withOpacity(0.1)
                              : Colors.transparent,
                      border: Border(
                        bottom: BorderSide(
                          color:
                              index < methods.length - 1
                                  ? isDark
                                      ? Colors.grey.shade800
                                      : Colors.grey.shade200
                                  : Colors.transparent,
                          width: 1,
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          method.stringName,
                          style: TextStyle(
                            color: method.color,
                            fontWeight:
                                isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                            fontSize: context.scaleText(14),
                          ),
                        ),
                        if (isSelected)
                          Icon(
                            Icons.check,
                            color: method.color,
                            size: context.scaleIcon(16),
                          ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
