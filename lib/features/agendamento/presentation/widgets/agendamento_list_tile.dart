import 'package:flutter/material.dart';

class AgendamentoListTile extends StatelessWidget {
  const AgendamentoListTile({
    super.key,
    required this.horario,
    required this.nomeCliente,
    required this.nomeServico,
    required this.status,
    required this.statusTextColor,
    required this.onTap,
  });

  final String horario;
  final String nomeCliente;
  final String nomeServico;
  final String status;
  final Color statusTextColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return ListTile(
      isThreeLine: true,
      contentPadding: EdgeInsetsGeometry.symmetric(horizontal: 4),
      titleAlignment: ListTileTitleAlignment.center,
      leading: Container( // horário
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            color: colorScheme.secondary,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            horario,
            style: textTheme.bodyLarge?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      title: Text( // nome do cliente
        nomeCliente,
        style: textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.bold
        ),
      ),
      subtitle: Column( // nome do serviço e status do agendamento
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 2,
        children: [
          Text(
            nomeServico,
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),

          Text(
            status,
            style: textTheme.bodyMedium?.copyWith(
              color: statusTextColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
      onTap: onTap,
    );
  }
}