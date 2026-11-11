import 'package:flutter/material.dart';

class RelatoriosPage extends StatelessWidget {
  const RelatoriosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 4,
          children: [
            Text(
              'Relatórios',
              style: Theme.of(context).textTheme.headlineSmall,
            ),

            // TODO: conteúdo e estado
          ],
        ),
      ),
    );
  }
}
