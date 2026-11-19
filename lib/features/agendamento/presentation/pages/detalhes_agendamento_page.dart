import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import '../../../../app/di/dependencies.dart';
import '../../../../core/ui/app_material_banner.dart';
import '../../../../core/ui/layouts/secondary_layout.dart';
import '../../../../core/ui/primary_button.dart';
import '../../../../core/ui/secondary_button.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/utils/money_formatter.dart';
import '../../domain/agendamento.dart';
import '../extensions/status_agendamento_extension.dart';
import '../viewmodels/detalhes_agendamento_view_model.dart';

class DetalhesAgendamentoPage extends StatefulWidget {
  const DetalhesAgendamentoPage({
    required super.key,
    required this.id,
  });

  final int id;

  @override
  State<DetalhesAgendamentoPage> createState() =>
    _DetalhesAgendamentoPageState();
}

class _DetalhesAgendamentoPageState extends State<DetalhesAgendamentoPage> {

  late final DetalhesAgendamentoViewModel _viewModel;
  
  final DateFormatter _dateFormatter = getIt<DateFormatter>();
  final MoneyFormatter _moneyFormatter = getIt<MoneyFormatter>();

  @override
  void initState() {
    super.initState();

    _viewModel = getIt<DetalhesAgendamentoViewModel>();
    _viewModel.buscarAgendamento(widget.id);
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, child) {
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

        final agendamento = _viewModel.agendamento!;

        return _buildDetalhes(agendamento);
      },
    );
  }

  Widget _buildDetalhes(Agendamento agendamento) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    final agendamentoData = agendamento.realizado
      ? agendamento.atendimento!.realizadoEm.toLocal()
      : agendamento.dataHora.toLocal();

    // Formato: 09:30 • Cliente 1
    final agendamentoLabel = '${
      _dateFormatter.hourMinute(agendamentoData)
    } • ${agendamento.cliente.nome}';

    return SecondaryLayout(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              spacing: 8,
              children: [
                Text(
                  'Detalhes do agendamento',
                  style: textTheme.headlineSmall,
                ),

                // Card do agendamento
                SizedBox(
                  width: double.infinity,
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
                            _dateFormatter.detailedDate(agendamentoData),
                            style: textTheme.labelLarge?.copyWith(
                              color: colorScheme.primary,
                            ),
                          ),

                          Text(
                            agendamentoLabel,
                            style: textTheme.headlineSmall,
                          ),

                          Text(
                            agendamento.status.label,
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
                  'Serviço do atendimento',
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 4),
                  title: Text(
                    agendamento.servico.nome,
                    style: textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text('Preço do serviço'),
                  trailing: Text(
                    _moneyFormatter.format(agendamento.valorTotal),
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const Divider(thickness: 0.2),

                Row(
                  children: [
                    Text(
                      'Total previsto: ',
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const Spacer(),

                    Text(
                      _moneyFormatter.format(agendamento.valorTotal),
                      style: textTheme.bodyLarge?.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                Text(
                  'Observações',
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                Text(
                  agendamento.observacoes ?? 'Nenhuma observação',
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),

          _buildActions(agendamento.id, agendamento.status),
        ],
      ),
    );
  }

  // Botões
  Widget _buildActions(int agendamentoId, StatusAgendamento status) {
    return Column(
      children: [
        PrimaryButton(
          label: status == StatusAgendamento.realizado
            ? 'Marcar como não realizado'
            : 'Marcar como realizado',
          onPressed: _alterarStatus,
          isExpanded: true,
        ),

        const SizedBox(height: 4),

        SecondaryButton(
          label: 'Editar agendamento',
          onPressed: () => _abrirAtualizacao(agendamentoId),
          isExpanded: true,
        ),

        if (status == StatusAgendamento.agendado) ...[
          const SizedBox(height: 4),

          SecondaryButton(
            label: 'Cancelar agendamento',
            onPressed: _cancelarAgendamento,
            isExpanded: true,
            isDestructive: true,
          ),
        ],
      ],
    );
  }

  Future<void> _alterarStatus() async {
    final atualizado = await _viewModel.alterarStatus();

    if (!mounted) return;

    AppMaterialBanner.show(
      context,
      message: atualizado
        ? 'Agendamento atualizado com sucesso!'
        : _viewModel.errorMessage
          ?? 'Não foi possível atualizar o agendamento.',
      isError: !atualizado,
    );
  }

  Future<void> _abrirAtualizacao(int agendamentoId) async {
    final resultado = await context.pushNamed<bool>(
      RouteNames.atualizacaoAgendamento,
      pathParameters: {
        'id': agendamentoId.toString(),
      },
    );

    if (resultado == true) {
      await _viewModel.buscarAgendamento(agendamentoId);

      if (!mounted) return;

      AppMaterialBanner.show(
        context,
        message: 'Agendamento atualizado com sucesso!',
      );
    }
  }

  Future<void> _cancelarAgendamento() async {
    final cancelado = await _viewModel.cancelarAgendamento();

    if (!mounted) return;

    if (cancelado) {
      context.pop(true);
      return;
    }

    AppMaterialBanner.show(
      context,
      message: _viewModel.errorMessage
        ?? 'Não foi possível cancelar o agendamento',
      isError: true,
    );
  }
}