import 'package:flutter/material.dart';

import '../../../../core/ui/primary_button.dart';
import '../../../../core/utils/phone_number_utils.dart';
import '../formatters/phone_number_input_formatter.dart';

/// Formulário para cadastrar ou editar clientes.
class ClienteForm extends StatelessWidget {
  const ClienteForm({
    super.key,
    required this.formKey,
    required this.nomeController,
    required this.telefoneController,
    required this.onSubmit,
    required this.isLoading,
    required this.submitLabel,
  });

  final GlobalKey<FormState> formKey;

  final TextEditingController nomeController;
  final TextEditingController telefoneController;

  final VoidCallback onSubmit;
  final bool isLoading;
  final String submitLabel;

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
                  hintText: 'Nome do cliente',
                  border: OutlineInputBorder(),
                ),
                validator: _validarNome,
              ),

              const SizedBox(height: 8),

              Text(
                'Telefone',
                style: textTheme.labelLarge?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.bold,
                ),
              ),

              TextFormField(
                maxLines: 1,
                controller: telefoneController,
                keyboardType: TextInputType.phone,
                autofillHints: const [AutofillHints.telephoneNumber],
                inputFormatters: [PhoneNumberInputFormatter()],
                decoration: InputDecoration(
                  hintText: '(00) 00000-0000',
                  border: const OutlineInputBorder(),
                ),
                validator: _validarTelefone,
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
      return 'Informe o nome do cliente';
    }

    if (nome.trim().length < 2) {
      return 'O nome deve ter pelo menos 2 caracteres';
    }

    return null;
  }

  String? _validarTelefone(String? telefone) {
    final digits = PhoneNumberUtils
      .onlyDigits(telefone ?? '');

    if (!PhoneNumberUtils.isValid(digits)) {
      return 'Telefone inválido';
    }

    return null;
  }
}
