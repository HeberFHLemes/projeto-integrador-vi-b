import 'package:flutter/material.dart';

/// Componente para fornecer feedback de operações ao usuário.
class AppMaterialBanner {
  static void show(
    BuildContext context, {
      required String message,
      bool isError = false,
      Duration duration = const Duration(seconds: 4),
  }) {
    final messenger = ScaffoldMessenger.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    messenger.hideCurrentMaterialBanner();

    messenger.showMaterialBanner(
      MaterialBanner(
        backgroundColor: isError
          ? colorScheme.errorContainer
          : colorScheme.primaryContainer,
        dividerColor: isError
          ? colorScheme.error
          : colorScheme.primary,
        leading: Icon(
          isError
            ? Icons.error_outline
            : Icons.check_circle_outline,
          color: Colors.white,
        ),
        content: Text(
          message,
          style: textTheme.labelLarge?.copyWith(
            color: isError
              ? colorScheme.onErrorContainer
              : colorScheme.onPrimaryContainer,
          ),
        ),
        actions: [
          IconButton(
            onPressed: messenger.hideCurrentMaterialBanner,
            icon: Icon(
              Icons.close,
              color: Colors.white,
            ),
            tooltip: 'Fechar',
          ),
        ],
      ),
    );

    Future.delayed(duration, () {
      messenger.hideCurrentMaterialBanner();
    });
  }
}
