import 'package:flutter/material.dart';

import '../../core/ui/layouts/secondary_layout.dart';

class SobrePage extends StatelessWidget {
  const SobrePage({super.key});

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

    return SecondaryLayout(
      child: ListView(
        scrollDirection: Axis.vertical,
        children: [
          Text('Sobre', style: textTheme.headlineSmall),

          // TODO: conteúdo
        ],
      ),
    );
  }
}