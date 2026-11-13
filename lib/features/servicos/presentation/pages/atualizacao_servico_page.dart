import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/di/dependencies.dart';
import '../../../../core/ui/app_material_banner.dart';
import '../../../../core/ui/layouts/secondary_layout.dart';
import '../../../../core/ui/secondary_button.dart';
import '../../../../core/utils/money_formatter.dart';
import '../viewmodels/atualizacao_servico_view_model.dart';
import '../widgets/servico_form.dart';

class AtualizacaoServicoPage extends StatefulWidget {
  const AtualizacaoServicoPage({
    super.key,
    required this.id,
  });

  final int id;

  @override
  State<StatefulWidget> createState() => _AtualizacaoServicoPageState();
}

class _AtualizacaoServicoPageState extends State<AtualizacaoServicoPage> {

  late final AtualizacaoServicoViewModel _viewModel;

  final _formKey = GlobalKey<FormState>();

  final _nomeController = TextEditingController();
  final _precoController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _viewModel = getIt<AtualizacaoServicoViewModel>();
    _carregarServico();
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _precoController.dispose();

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

        final servico = _viewModel.servico;

        if (servico == null) {
          return const SecondaryLayout(
            child: Center(
              child: Text('Serviço não encontrado.'),
            ),
          );
        }

        return SecondaryLayout(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Atualização de serviço',
                style: textTheme.headlineSmall,
              ),

              Expanded(
                child: ServicoForm(
                  formKey: _formKey,
                  nomeController: _nomeController,
                  precoController: _precoController,
                  onSubmit: _submit,
                  isLoading: _viewModel.isLoading,
                  submitLabel: 'Atualizar serviço',
                ),
              ),

              const SizedBox(height: 8),

              SecondaryButton(
                label: '${servico.ativo ? 'Desativar' : 'Ativar'} serviço',
                onPressed: _alterarStatusServico,
                isExpanded: true,
                isDestructive: servico.ativo,
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _carregarServico() async {
    await _viewModel.buscarServico(widget.id);

    if (!mounted) return;

    final servico = _viewModel.servico;

    if (servico != null) {
      _nomeController.text = servico.nome;

      // utilizando o formatador para preencher valor existente
      _precoController.text = MoneyFormatter().format(servico.preco);
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final nome = _nomeController.text.trim();

    final preco = int.parse(
      _precoController.text.replaceAll(RegExp(r'\D'), ''),
    );

    await _viewModel.atualizarServico(
      nome: nome,
      preco: preco,
    );

    if (!mounted) return;

    if (_viewModel.errorMessage == null) {
      context.pop(true);
    }
    else {
      _formKey.currentState?.reset();

      AppMaterialBanner.show(
        context,
        message: _viewModel.errorMessage!,
        isError: true,
      );
    }
  }

  Future<void> _alterarStatusServico() async {
    await _viewModel.alterarStatusServico();

    if (!mounted) return;

    if (_viewModel.errorMessage == null) {
      return context.pop(true);
    }

    AppMaterialBanner.show(
      context,
      message: _viewModel.errorMessage!,
      isError: true,
    );
  }
}