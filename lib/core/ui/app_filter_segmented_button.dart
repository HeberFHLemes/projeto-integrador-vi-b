import 'package:flutter/material.dart';

/// Componente para seleção de filtros com SegmentedButton.
class AppFilterSegmentedButton<T> extends StatelessWidget {
  const AppFilterSegmentedButton({
    super.key,
    required this.segments,
    required this.selected,
    required this.onSelectionChanged,
  });

  final List<ButtonSegment<T>> segments;
  final Set<T> selected;
  final ValueChanged<Set<T>> onSelectionChanged;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: colorScheme.tertiary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: SegmentedButton<T>(
        showSelectedIcon: false,
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return Colors.white;
            }
            return Colors.transparent;
          }),
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return colorScheme.primary;
            }
            return colorScheme.onSurfaceVariant;
          }),
          side: const WidgetStatePropertyAll(
            BorderSide(color: Colors.transparent),
          ),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          overlayColor: const WidgetStatePropertyAll(
            Colors.transparent,
          ),
        ),
        segments: segments,
        selected: selected,
        onSelectionChanged: onSelectionChanged,
      ),
    );
  }
}