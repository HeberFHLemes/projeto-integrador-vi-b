import 'package:flutter/material.dart';

import '../../core/ui/voltar_button.dart';

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
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const VoltarButton(),
        automaticallyImplyActions: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: ListView(
            scrollDirection: Axis.vertical,
            children: [
              Text('Sobre', style: textTheme.headlineSmall),

              // TODO: conteúdo
            ],
          ),
        ),
      ),
    );
  }
}