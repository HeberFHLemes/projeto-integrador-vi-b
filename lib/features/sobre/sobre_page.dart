import 'package:flutter/material.dart';

import '../../core/widgets/voltar_button.dart';

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

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const VoltarButton(),

              Text('Sobre', style: textTheme.headlineSmall),

              // TODO: conteúdo
            ],
          ),
        ),
      ),
    );
  }
}