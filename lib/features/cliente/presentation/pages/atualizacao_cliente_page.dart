import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/di/dependencies.dart';
import '../../../../core/ui/app_material_banner.dart';
import '../../../../core/ui/layouts/secondary_layout.dart';
import '../../../../core/ui/secondary_button.dart';
import '../../../../core/utils/phone_number_utils.dart';
import '../viewmodels/atualizacao_cliente_view_model.dart';
import '../widgets/cliente_form.dart';

class AtualizacaoClientePage extends StatefulWidget {
  const AtualizacaoClientePage({
    super.key,
    required this.id,
  });

  final int id;

  @override
  State<StatefulWidget> createState() => _AtualizacaoClientePageState();
}

class _AtualizacaoClientePageState extends State<AtualizacaoClientePage> {

  late final AtualizacaoClienteViewModel _viewModel;

  final _formKey = GlobalKey<FormState>();

  final _nomeController = TextEditingController();
  final _telefoneController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _viewModel = getIt<AtualizacaoClienteViewModel>();
    _carregarCliente();
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _telefoneController.dispose();

    _viewModel.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

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

        final cliente = _viewModel.cliente;

        if (cliente == null) {
          return const SecondaryLayout(
            child: Center(
              child: Text('Cliente não encontrado.'),
            ),
          );
        }

        return SecondaryLayout(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 8,
            children: [
              Text(
                'Atualização de cliente',
                style: textTheme.headlineSmall,
              ),

              const SizedBox(height: 8),

              Text(
                'Dados do cliente',
                style: textTheme.labelLarge?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.bold,
                ),
              ),

              Expanded(
                child: ClienteForm(
                  formKey: _formKey,
                  nomeController: _nomeController,
                  telefoneController: _telefoneController,
                  onSubmit: _submit,
                  isLoading: _viewModel.isLoading,
                  submitLabel: 'Atualizar cliente',
                ),
              ),

              SecondaryButton(
                label: '${cliente.ativo ? 'Desativar' : 'Ativar'} cliente',
                onPressed: _alterarStatusCliente,
                isExpanded: true,
                isDestructive: cliente.ativo,
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _carregarCliente() async {
    await _viewModel.buscarCliente(widget.id);

    if (!mounted) return;

    final cliente = _viewModel.cliente;

    if (cliente != null) {
      _nomeController.text = cliente.nome;

      // utilizando o formatador para preencher valor existente
      _telefoneController.text = PhoneNumberUtils.format(cliente.telefone);
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    await _viewModel.atualizarCliente(
      nome: _nomeController.text,
      telefone: _telefoneController.text,
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

  Future<void> _alterarStatusCliente() async {
    await _viewModel.alterarStatusCliente();

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