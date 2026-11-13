import 'package:flutter/material.dart';

import '../../../../core/ui/primary_button.dart';
import '../formatters/money_input_formatter.dart';

/// Formulário para cadastrar ou editar serviços.
class ServicoForm extends StatelessWidget {
  const ServicoForm({
    super.key,
    required this.formKey,
    required this.nomeController,
    required this.precoController,
    required this.onSubmit,
    required this.isLoading,
    required this.submitLabel,
    this.priceMaxLength = 12,
  });

  final GlobalKey<FormState> formKey;

  final TextEditingController nomeController;
  final TextEditingController precoController;

  final VoidCallback onSubmit;
  final bool isLoading;
  final String submitLabel;

  final int priceMaxLength;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Form(
      key: formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 8,
        children: [
          Column(
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
                maxLength: 50,
                controller: nomeController,
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
                controller: precoController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  // Impedindo digitação de caracteres além do limite
                  // no próprio formatador.
                  MoneyInputFormatter(maxLength: priceMaxLength),
                ],
                decoration: InputDecoration(
                  hintText: 'Preço do serviço',
                  border: const OutlineInputBorder(),
                ),
                validator: _validarPreco,
              ),
            ],
          ),

          // Botão de submit do formulário
          PrimaryButton(
            label: submitLabel,
            onPressed: isLoading ? null : onSubmit,
            isExpanded: true,
          ),
        ],
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
}