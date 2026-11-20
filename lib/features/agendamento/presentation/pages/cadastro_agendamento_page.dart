import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/di/dependencies.dart';
import '../../../../core/ui/app_material_banner.dart';
import '../../../../core/ui/layouts/secondary_layout.dart';
import '../../../../core/utils/date_formatter.dart';
import '../viewmodels/cadastro_agendamento_view_model.dart';
import '../widgets/agendamento_form.dart';

class CadastroAgendamentoPage extends StatefulWidget {
  const CadastroAgendamentoPage({
    super.key,
    this.dataInicial,
  });

  final DateTime? dataInicial;

  @override
  State<CadastroAgendamentoPage> createState() => _CadastroAgendamentoPageState();
}

class _CadastroAgendamentoPageState extends State<CadastroAgendamentoPage> {

  late final CadastroAgendamentoViewModel _viewModel;

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _observacoesController = TextEditingController();

  final DateFormatter _dateFormatter = getIt<DateFormatter>();

  @override
  void initState() {
    super.initState();

    _viewModel = getIt<CadastroAgendamentoViewModel>();
    _viewModel.selecionarData(widget.dataInicial);
    _viewModel.carregar();
  }

  @override
  void dispose() {
    _observacoesController.dispose();
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, _) {
        if (_viewModel.isLoading) {
          return const SecondaryLayout(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (_viewModel.errorMessage != null) {
          return SecondaryLayout(
            child: Center(
              child: Text(_viewModel.errorMessage!),
            ),
          );
        }

        return SecondaryLayout(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 8,
            children: [
              Text(
                'Novo agendamento',
                style: textTheme.headlineSmall,
              ),

              const SizedBox(height: 8),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(8),
                  child: AgendamentoForm(
                    formKey: _formKey,
                    clientes: _viewModel.clientes,
                    servicos: _viewModel.servicos,
                    clienteId: _viewModel.clienteId,
                    servicoId: _viewModel.servicoId,
                    data: _viewModel.data,
                    horario: _viewModel.horario,
                    observacoesController: _observacoesController,
                    onClienteChanged: _viewModel.selecionarCliente,
                    onServicoChanged: _viewModel.selecionarServico,
                    onDataPressed: _selecionarData,
                    onHorarioPressed: _selecionarHorario,
                    onSubmit: _submit,
                    isLoading: _viewModel.isSaving,
                    dateFormatter: _dateFormatter,
                  ),
                ),
              ),
            ],
          ),
        );
      }
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    _viewModel.atualizarObservacoes(_observacoesController.text);

    final sucesso = await _viewModel.cadastrar();

    if (!mounted) return;

    if (sucesso && _viewModel.errorMessage == null) {
      context.pop(true);

    } else {
      AppMaterialBanner.show(
        context,
        message: _viewModel.errorMessage!,
        isError: true,
      );
    }
  }

  Future<void> _selecionarData() async {
    final now = DateTime.now();
    final dataSelecionada = await showDatePicker(
      context: context,
      initialDate: _viewModel.data ?? now,
      firstDate: now,
      lastDate: DateTime(now.year + 2),
    );

    if (dataSelecionada != null) {
      _viewModel.selecionarData(dataSelecionada);
    }
  }

  Future<void> _selecionarHorario() async {
    final horarioSelecionado = await showTimePicker(
      context: context,
      initialTime: _viewModel.horario ?? TimeOfDay.now(),
    );

    if (horarioSelecionado != null) {
      _viewModel.selecionarHorario(horarioSelecionado);
    }
  }
}