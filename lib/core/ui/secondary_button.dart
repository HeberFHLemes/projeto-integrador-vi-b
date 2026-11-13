import 'package:flutter/material.dart';

class SecondaryButton extends StatelessWidget {
  const SecondaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.height = kToolbarHeight,
    this.isExpanded = false,
    this.isDestructive = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final double? height;
  final bool isExpanded;
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    final color = isDestructive
      ? Theme.of(context).colorScheme.error
      : null;

    final buttonStyle = ButtonStyle(
      backgroundColor: const WidgetStatePropertyAll(
        Colors.transparent,
      ),
      foregroundColor: WidgetStatePropertyAll(color),
      shape: const WidgetStatePropertyAll(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
      ),
    );

    final button = TextButton(
      onPressed: onPressed,
      style: buttonStyle,
      child: Text(label),
    );

    return SizedBox(
      width: isExpanded ? double.infinity : null,
      height: height,
      child: button,
    );
  }
}
