import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Layout básico para as páginas de formulário e de detalhes.
class SecondaryLayout extends StatelessWidget {
  const SecondaryLayout({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyActions: false,
        automaticallyImplyLeading: false,
        title: TextButton.icon(
            onPressed: context.pop,
            icon: const Icon(Icons.chevron_left),
            label: const Text('Voltar'),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.only(right: 8),
              alignment: Alignment.centerLeft,
              foregroundColor: Theme.of(context).colorScheme.primary,
            ),
          ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
              left: 20, right: 20, bottom: 20
          ),
          child: child,
        ),
      ),
    );
  }
}