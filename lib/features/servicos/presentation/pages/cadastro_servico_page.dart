import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/di/dependencies.dart';
import '../../../../core/ui/app_material_banner.dart';
import '../../../../core/ui/primary_button.dart';
import '../../../../core/ui/voltar_button.dart';
import '../formatters/money_input_formatter.dart';
import '../viewmodels/cadastro_servico_view_model.dart';

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

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyActions: false,
        automaticallyImplyLeading: false,
        title: const VoltarButton(),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_viewModel.errorMessage != null)
                Text(
                  _viewModel.errorMessage!,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),

              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: 8,
                children: [
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

                  Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      spacing: 8,
                      children: [
                        Text(
                          'Nome',
                          style: textTheme.labelLarge?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        // Campo para nome
                        TextFormField(
                          maxLines: 1,
                          maxLength: 30,
                          controller: _nomeController,
                          decoration: InputDecoration(
                            hintText: 'Nome do serviço',
                            border: OutlineInputBorder(),
                          ),
                          validator: _validarNome,
                        ),

                        const SizedBox(height: 8,),

                        Text(
                          'Preço',
                          style: textTheme.labelLarge?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        TextFormField(
                          maxLines: 1,
                          maxLength: 15, // Evitar atingir limite de int
                          controller: _precoController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            MoneyInputFormatter(),
                          ],
                          decoration: InputDecoration(
                            hintText: 'Preço do serviço',
                            border: const OutlineInputBorder(),
                          ),
                          validator: _validarPreco,
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const Spacer(),


              PrimaryButton(
                label: 'Cadastrar serviço',
                onPressed: _viewModel.isLoading ? null : _submit,
                isExpanded: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String? _validarNome(String? nome) {
    if (nome == null || nome.trim().isEmpty) {
      return 'Informe o nome do serviço';
    }

    if (nome.trim().length < 2) {
      return 'O nome deve ter pelo menos 2 caracteres';
    }

    return null;
  }

  String? _validarPreco(String? preco) {
    if (preco == null || preco.isEmpty) {
      return 'Informe o preço do serviço';
    }

    final centavos = int.tryParse(
      preco.replaceAll(RegExp(r'\D'), ''),
    );

    if (centavos == null || centavos < 0) {
      return 'Informe um preço válido';
    }

    return null;
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