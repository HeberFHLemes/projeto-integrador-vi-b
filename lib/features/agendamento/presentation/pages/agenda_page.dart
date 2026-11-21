import 'package:agendados/features/agendamento/presentation/enums/resultado_agendamento.dart';
import 'package:agendados/features/agendamento/presentation/pages/cadastro_agendamento_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/di/dependencies.dart';
import '../../../../app/router/route_names.dart';
import '../../../../core/ui/app_material_banner.dart';
import '../../../../core/ui/primary_button.dart';
import '../../../../core/utils/date_formatter.dart';
import '../extensions/status_agendamento_extension.dart';
import '../viewmodels/agenda_view_model.dart';
import '../widgets/agendamento_list_tile.dart';
import '../widgets/day_selector.dart';

class AgendaPage extends StatefulWidget {
  const AgendaPage({super.key});

  @override
  State<StatefulWidget> createState() => _AgendaPageState();
}

class _AgendaPageState extends State<AgendaPage> {

  final DateFormatter _dateFormatter = getIt<DateFormatter>();

  late final AgendaViewModel _viewModel;

  @override
  void initState() {
    super.initState();

    _viewModel = getIt<AgendaViewModel>();
    _viewModel.carregarAgendamentos();
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
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 8,
              children: [
                Text('Agenda', style: Theme.of(context).textTheme.headlineSmall),

                const SizedBox(height: 4),

                DaySelector(
                  selectedDate: _viewModel.dataSelecionada,
                  onDateChanged: _viewModel.selecionarData,
                  dateFormatter: _dateFormatter,
                ),

                Expanded(child: buildAgendamentos()),

                PrimaryButton(
                  label: 'Agendar',
                  icon: Icons.add,
                  onPressed: _abrirCadastro,
                  isExpanded: true,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _abrirCadastro() async {
    final resultado = await context.pushNamed<bool>(
      RouteNames.novoAgendamento,
      // enviando ao formulário a data selecionada
      // para ser usada como valor inicial do campo data.
      extra: CadastroAgendamentoArgs(
        dataInicial: _viewModel.dataSelecionada,
      ),
    );

    if (!mounted) return;

    if (resultado == true) {
      AppMaterialBanner.show(
        context,
        message: 'Agendamento cadastrado com sucesso!',
      );

      _viewModel.carregarAgendamentos();
    }
  }

  Widget buildAgendamentos() {
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

    if (_viewModel.agendamentos.isEmpty) {
      return const Center(
        child: Text('Nenhum agendamento encontrado.'),
      );
    }

    int quantidade = _viewModel.agendamentos.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        Text(
          "$quantidade ${quantidade == 1 ? 'atendimento' : 'atendimentos'}",
          style: Theme.of(context).textTheme.labelMedium,
        ),

        Expanded(
          child: ListView.separated(
            itemCount: quantidade,
            itemBuilder: (context, index) {
              final agendamento = _viewModel.agendamentos[index];

              return AgendamentoListTile(
                horario: _dateFormatter.hourMinute(
                  agendamento.dataHora.toLocal()
                ),
                nomeCliente: agendamento.cliente.nome,
                nomeServico: agendamento.servico.nome,
                status: agendamento.status.label,
                statusTextColor: agendamento.status.color(
                  Theme.of(context).colorScheme
                ),
                onTap: () => _abrirDetalhes(agendamento.id),
              );
            },
            separatorBuilder: (context, state) => const SizedBox(height: 4),
          ),
        ),
      ],
    );
  }

  Future<void> _abrirDetalhes(int agendamentoId) async {
    final resultado = await context.pushNamed<ResultadoAgendamento>(
      RouteNames.detalhesAgendamento,
      pathParameters: { 'id': agendamentoId.toString() },
    );

    if (!mounted || resultado == null) return;

    if (resultado == ResultadoAgendamento.cancelado) {
      AppMaterialBanner.show(
        context,
        message: 'Agendamento cancelado com sucesso!',
      );
    }

    _viewModel.carregarAgendamentos();
  }
}
