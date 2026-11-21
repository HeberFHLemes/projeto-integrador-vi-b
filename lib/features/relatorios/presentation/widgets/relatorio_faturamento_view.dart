import 'package:flutter/material.dart';

import '../../../../core/utils/date_formatter.dart';
import '../../../../core/utils/money_formatter.dart';
import '../../domain/relatorio_faturamento.dart';

class RelatorioFaturamentoView extends StatelessWidget {
  const RelatorioFaturamentoView({
    super.key,
    required this.faturamento,
    required this._moneyFormatter,
    required this._dateFormatter,
    required this.onAtendimentoPressed,
  });

  final RelatorioFaturamento? faturamento;
  final MoneyFormatter _moneyFormatter;
  final DateFormatter _dateFormatter;
  final ValueChanged<int> onAtendimentoPressed;

  @override
  Widget build(BuildContext context) {
    final faturamento = this.faturamento;

    if (faturamento == null) {
      return const Center(
        child: Text('Não foi possível obter o relatório de faturamento.'),
      );
    }

    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      spacing: 8,
      children: [
        // Card com o total e quantidade de atendimentos no período
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
                    'Serviços realizados',
                    style: textTheme.labelLarge?.copyWith(
                      color: colorScheme.primary,
                    ),
                  ),

                  Text(
                    _moneyFormatter.format(faturamento.total),
                    style: textTheme.headlineSmall,
                  ),

                  Text(
                    "${faturamento.quantidadeAtendimentos} ${
                      faturamento.quantidadeAtendimentos > 1
                        ? 'atendimentos' : 'atendimento'
                    } no período",
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        ListTile(
          contentPadding: EdgeInsetsGeometry.symmetric(horizontal: 4),
          title: Text(
            'Total recebido',
            style: textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold
            ),
          ),
          subtitle: Text('Pagamentos registrados'),
          trailing: Text(
            _moneyFormatter.format(faturamento.total),
            style: textTheme.labelLarge?.copyWith(
              color: colorScheme.primary,
            ),
          ),
        ),

        const Divider(thickness: 0.2),

        Text(
          'Atendimentos realizados',
          style: textTheme.labelLarge?.copyWith(
            color: colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.bold,
          ),
        ),

        Expanded(
          child: ListView.separated(
            itemCount: faturamento.atendimentos.length,
            itemBuilder: (context, index) {
              final atendimento = faturamento.atendimentos[index];

              final titulo = "${
                  _dateFormatter.dayMonth(atendimento.realizadoEm)
              } • ${atendimento.clienteNome}";

              return ListTile(
                contentPadding: EdgeInsetsGeometry.symmetric(horizontal: 4),
                title: Text(
                  titulo,
                  style: textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold
                  ),
                ),
                subtitle: Text(atendimento.servicoNome),
                trailing: Text(
                  _moneyFormatter.format(atendimento.valorCobrado),
                  style: textTheme.labelLarge?.copyWith(
                    color: colorScheme.primary,
                  ),
                ),
                onTap: () => onAtendimentoPressed(
                  atendimento.agendamentoId,
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