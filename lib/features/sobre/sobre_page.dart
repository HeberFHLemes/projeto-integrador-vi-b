import 'package:flutter/material.dart';

import '../../core/ui/layouts/secondary_layout.dart';

class SobrePage extends StatelessWidget {
  const SobrePage({super.key});

  static const String _logoPath = 'assets/images/logo_vertical.png';

  static const String _descricao =
      'Aplicativo de gestão de agendamentos para profissionais '
      'e pequenos negócios.';

  static const List<String> _nomes = [
    'Héber Lemes',
    'Maicon Rodrigues',
    'Natanael Rocha',
    'Nicolas Farina',
    'Raphael de Aguiar Ribeiro',
  ];

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return SecondaryLayout(
      child: ListView(
        scrollDirection: Axis.vertical,
        children: [
          Text('Sobre', style: textTheme.headlineSmall),
          const SizedBox(height: 24),

          // Logo
          Center(
            child: Image.asset(
              _logoPath,
              height: 140,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 24),

          // Descrição do aplicativo
          Text(
            _descricao,
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Projeto Integrador VI-B',
            style: textTheme.labelSmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),

          // Integrantes
          Text('Integrantes do grupo', style: textTheme.titleMedium),
          const SizedBox(height: 2),
          Text(
            'Grupo 5 · Turma MA',
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 12),
          const Divider(),
          const SizedBox(height: 4),

          for (final nome in _nomes)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Text(
                nome,
                style: textTheme.bodyMedium?.copyWith(fontSize: 16),
              ),
            ),
        ],
      ),
    );
  }
}
