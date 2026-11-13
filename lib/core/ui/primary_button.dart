import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.height = kToolbarHeight,
    this.isExpanded = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final double? height;
  final bool isExpanded;

  @override
  Widget build(BuildContext context) {
    final buttonStyle = ButtonStyle(
      shape: WidgetStateProperty.all(
        const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(8)
          ),
        ),
      ),
    );

    final button = icon == null
        ? FilledButton(
      onPressed: onPressed,
      style: buttonStyle,
      child: Text(label),
    )
        : FilledButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      style: buttonStyle,
      label: Text(label),
    );

    return SizedBox(
      width: isExpanded ? double.infinity : null,
      height: height,
      child: button,
    );
  }
}
