import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/di/dependencies.dart';
import '../../../../core/ui/app_material_banner.dart';
import '../../../../core/ui/layouts/secondary_layout.dart';
import '../widgets/cliente_form.dart';
import '../viewmodels/cadastro_cliente_view_model.dart';

class CadastroClientePage extends StatefulWidget {
  const CadastroClientePage({super.key});

  @override
  State<CadastroClientePage> createState() => _CadastroClientePageState();
}

class _CadastroClientePageState extends State<CadastroClientePage> {
  late final CadastroClienteViewModel _viewModel;

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _telefoneController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _viewModel = getIt<CadastroClienteViewModel>();
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

    return SecondaryLayout(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 8,
        children: [
          if (_viewModel.errorMessage != null)
            Text(
              _viewModel.errorMessage!,
              style: TextStyle(
                color:
                colorScheme.error,
              ),
            ),

          Text(
           'Cadastro de cliente',
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
              submitLabel: 'Cadastrar cliente',
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    await _viewModel.cadastrarCliente(
      nome: _nomeController.text,
      telefone: _telefoneController.text,
    );

    if (!mounted) return;

    if (_viewModel.errorMessage == null) {
      context.pop(true);

    } else {
      AppMaterialBanner.show(
        context,
        message: _viewModel.errorMessage!,
        isError: true,
      );
    }
  }
}