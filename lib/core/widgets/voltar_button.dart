import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class VoltarButton extends StatelessWidget {
  const VoltarButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: TextButton.icon(
        onPressed: () => context.canPop() ? context.pop() : context.go('/'),
        icon: const Icon(Icons.chevron_left),
        label: const Text('Voltar'),
        style: TextButton.styleFrom(
          padding: EdgeInsets.only(right: 8),
          alignment: Alignment.centerLeft,
          foregroundColor: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}