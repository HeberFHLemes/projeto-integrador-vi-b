import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/di/dependencies.dart';
import '../../../../core/ui/app_material_banner.dart';
import '../../../../core/ui/layouts/secondary_layout.dart';
import '../viewmodels/cadastro_servico_view_model.dart';
import '../widgets/servico_form.dart';

class CadastroServicoPage extends StatefulWidget {
  const CadastroServicoPage({super.key});

  @override
  State<StatefulWidget> createState() => _CadastroServicoPageState();
}

class _CadastroServicoPageState extends State<CadastroServicoPage> {
  late final CadastroServicoViewModel _viewModel;

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _precoController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _viewModel = getIt<CadastroServicoViewModel>();
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
                color: Theme.of(context).colorScheme.error,
              ),
            ),

          Text(
            'Cadastro de serviço',
            style: textTheme.headlineSmall,
          ),

          const SizedBox(height: 8),

          Text(
            'Dados do serviço',
            style: textTheme.labelLarge?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 4),

          // Formulário em si
          Expanded(
            child: ServicoForm(
              formKey: _formKey,
              nomeController: _nomeController,
              precoController: _precoController,
              onSubmit: _submit,
              isLoading: _viewModel.isLoading,
              submitLabel: 'Cadastrar serviço',
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final nome = _nomeController.text.trim();

    final preco = int.parse(
      _precoController.text.replaceAll(RegExp(r'\D'), ''),
    );

    await _viewModel.cadastrarServico(
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
}