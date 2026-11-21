import 'package:flutter/material.dart';

import '../../../../core/utils/date_formatter.dart';
import '../../domain/relatorio_frequencia.dart';

class RelatorioFrequenciaView extends StatelessWidget {
  const RelatorioFrequenciaView({
    super.key,
    required this.frequencia,
    required this._dateFormatter,
    required this.onClientePressed,
  });

  final RelatorioFrequencia? frequencia;
  final DateFormatter _dateFormatter;
  final ValueChanged<int> onClientePressed;

  @override
  Widget build(BuildContext context) {
    final frequencia = this.frequencia;

    if (frequencia == null) {
      return const Center(
        child: Text(
          'Não foi possível obter o relatório de clientes frequentes.'
        ),
      );
    }

    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    final labelTotalClientes = "${frequencia.quantidadeClientes} ${
      frequencia.quantidadeClientes == 1 ? 'cliente' : 'clientes'
    }";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      spacing: 8,
      children: [
        // Card com o total de clientes atendidos no período
        SizedBox(
          width: double.maxFinite,
          child: Card(
            elevation: 0,
            color: colorScheme.secondary,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Frequência no período',
                    style: textTheme.labelLarge?.copyWith(
                      color: colorScheme.primary,
                    ),
                  ),

                  Text(
                    labelTotalClientes,
                    style: textTheme.headlineSmall,
                  ),

                  Text(
                    "Considera apenas atendimentos realizados",
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        Text(
          'Clientes por número de visitas',
          style: textTheme.labelLarge?.copyWith(
            color: colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.bold,
          ),
        ),

        Expanded(
          child: ListView.separated(
            itemCount: frequencia.clientes.length,
            itemBuilder: (context, index) {
              final cliente = frequencia.clientes[index];

              final posicao = (index + 1).toString().padLeft(2, '0');
              final titulo = "$posicao ${cliente.nome}";

              final ultimaVisita = _dateFormatter.dayMonth(
                cliente.ultimaVisita
              );

              final quantidadeVisitasLabel = "${
                cliente.quantidadeAtendimentos
              } ${cliente.quantidadeAtendimentos == 1 ? 'visita' : 'visitas'}";

              return ListTile(
                contentPadding: EdgeInsetsGeometry.symmetric(horizontal: 4),
                title: Text(
                  titulo,
                  style: textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold
                  ),
                ),
                subtitle: Text("Última visita em $ultimaVisita"),
                trailing: Text(
                  quantidadeVisitasLabel,
                  style: textTheme.labelLarge?.copyWith(
                    color: colorScheme.primary,
                  ),
                ),
                onTap: () => onClientePressed(
                  cliente.id,
                ),
              );
            },
            separatorBuilder: (_, _) => const Divider(thickness: 0.2),
          ),
        ),
      ],
    );
  }
}
