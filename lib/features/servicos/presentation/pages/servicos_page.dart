import 'package:flutter/material.dart';

class ServicosPage extends StatelessWidget {
  const ServicosPage({super.key});

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
              'Serviços',
              style: Theme.of(context).textTheme.headlineSmall,
            ),

            // TODO: conteúdo e estado
          ],
        ),
      ),
    );
  }
}
