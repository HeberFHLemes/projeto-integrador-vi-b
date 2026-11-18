import 'package:flutter/material.dart';

class AgendamentoClienteListTile extends StatelessWidget {
  const AgendamentoClienteListTile({
    super.key,
    required this.dataAgendamento,
    required this.servico,
    required this.status,
    required this.preco,
    required this.onTap,
  });

  final String dataAgendamento;
  final String servico;
  final String status;
  final String preco;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsetsGeometry.symmetric(horizontal: 4),
      title: Text(
        dataAgendamento,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.bold
        ),
      ),
      subtitle: Text('$servico • $status'),
      trailing: Text(
        preco,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      onTap: onTap,
    );
  }
}
