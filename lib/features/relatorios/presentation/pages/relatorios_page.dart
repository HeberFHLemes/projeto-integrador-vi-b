import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/di/dependencies.dart';
import '../../../../app/router/route_names.dart';
import '../../../../core/utils/money_formatter.dart';
import '../../../../core/ui/app_filter_segmented_button.dart';
import '../../../../core/utils/date_formatter.dart';
import '../viewmodels/relatorios_view_model.dart';
import '../widgets/relatorio_faturamento_view.dart';

class RelatoriosPage extends StatefulWidget {
  const RelatoriosPage({super.key});

  @override
  State<RelatoriosPage> createState() => _RelatoriosPageState();
}

class _RelatoriosPageState extends State<RelatoriosPage> {

  late final RelatoriosViewModel _viewModel;

  final DateFormatter _dateFormatter = getIt<DateFormatter>();
  final MoneyFormatter _moneyFormatter = getIt<MoneyFormatter>();

  @override
  void initState() {
    super.initState();

    _viewModel = getIt<RelatoriosViewModel>();
    _viewModel.carregarRelatorio();
  }

  @override
  void dispose() {
    _viewModel.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, child) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 8,
              children: [
                Text(
                  'Relatórios',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),

                const SizedBox(height: 8),

                // Seletor de tipo de relatório
                AppFilterSegmentedButton<TipoRelatorio>(
                  segments: const [
                    ButtonSegment<TipoRelatorio>(
                      value: TipoRelatorio.faturamento,
                      label: Text('Faturamento'),
                    ),
                    ButtonSegment<TipoRelatorio>(
                      value: TipoRelatorio.frequencia,
                      label: Text('Clientes frequentes'),
                    ),
                  ],
                  selected: {_viewModel.tipoRelatorio},
                  onSelectionChanged: (tipo) {
                    _viewModel.alterarTipoRelatorio(tipo.first);
                  },
                ),

                const SizedBox(height: 4),

                Text(
                  'Período',
                  style: textTheme.labelLarge?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                // Seletor de período
                InkWell(
                  onTap: _selecionarPeriodo,
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.search),
                    ),
                    child: Text(
                      _dateFormatter.dateRange(
                        _viewModel.inicio,
                        _viewModel.fim,
                      ),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ),

                // Relatório em si
                Expanded(child: _buildRelatorio()),
              ],
            ),
          ),
        );
      }
    );
  }

  Widget _buildRelatorio() {
    if (_viewModel.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_viewModel.errorMessage != null) {
      return Center(
        child: Text(_viewModel.errorMessage!),
      );
    }

    // TODO: Componentes para cada relatório
    return switch (_viewModel.tipoRelatorio) {
      TipoRelatorio.faturamento => RelatorioFaturamentoView(
        faturamento: _viewModel.relatorioFaturamento,
        moneyFormatter: _moneyFormatter,
        dateFormatter: _dateFormatter,
        onAtendimentoPressed: _abrirDetalhesAgendamento,
      ),
      TipoRelatorio.frequencia =>
        Center(child: Text('Relatórios - Clientes frequentes')),
    };
  }

  Future<void> _selecionarPeriodo() async {
    final periodo = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2026),
      lastDate: DateTime(2028),
      initialDateRange: DateTimeRange(
        start: _viewModel.inicio,
        end: _viewModel.fim,
      ),
    );

    if (periodo != null) {
      await _viewModel.alterarPeriodo(
        inicio: periodo.start,
        fim: periodo.end,
      );
    }
  }

  void _abrirDetalhesAgendamento(int id) {
    context.goNamed(
      RouteNames.detalhesAgendamento,
      pathParameters: {
        'id': id.toString(),
      },
    );
  }
}
