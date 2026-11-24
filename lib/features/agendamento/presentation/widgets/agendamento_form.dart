import 'package:flutter/material.dart';

import '../../../../core/ui/primary_button.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../cliente/domain/cliente.dart';
import '../../../servicos/domain/servico.dart';

/// Formulário para cadastrar ou editar agendamentos.
class AgendamentoForm extends StatelessWidget {
  const AgendamentoForm({
    super.key,
    required this.formKey,
    required this.clientes,
    required this.servicos,
    required this.clienteId,
    required this.servicoId,
    required this.data,
    required this.horario,
    required this.observacoesController,
    required this.onClienteChanged,
    required this.onServicoChanged,
    required this.onDataPressed,
    required this.onHorarioPressed,
    required this.onSubmit,
    required this.isLoading,
    required this._dateFormatter,
  });

  final GlobalKey<FormState> formKey;

  final List<Cliente> clientes;
  final List<Servico> servicos;

  final int? clienteId;
  final int? servicoId;

  final DateTime? data;
  final TimeOfDay? horario;

  final TextEditingController observacoesController;

  final ValueChanged<int?> onClienteChanged;
  final ValueChanged<int?> onServicoChanged;

  final VoidCallback onDataPressed;
  final VoidCallback onHorarioPressed;

  final VoidCallback onSubmit;
  final bool isLoading;

  final DateFormatter _dateFormatter;

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
                'Cliente',
                style: textTheme.labelLarge?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.bold,
                ),
              ),

              // Cliente
              DropdownButtonFormField<int>(
                initialValue: clienteId,
                decoration: InputDecoration(
                  labelText: (clientes.isNotEmpty)
                    ? 'Selecionar cliente'
                    : 'Nenhum cliente encontrado',
                ),
                items: [
                  for (final cliente in clientes)
                    DropdownMenuItem(
                      value: cliente.id,
                      child: Text(cliente.nome),
                    ),
                ],
                onChanged: onClienteChanged,
                validator: (value) =>
                  value == null
                    ? 'Selecione um cliente.'
                    : null,
              ),

              const SizedBox(height: 16),

              Text(
                'Tipo de serviço',
                style: textTheme.labelLarge?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.bold,
                ),
              ),

              // Serviço
              DropdownButtonFormField<int>(
                initialValue: servicoId,
                decoration: InputDecoration(
                  labelText: (servicos.isNotEmpty)
                    ? 'Selecionar um serviço'
                    : 'Nenhum serviço encontrado',
                ),
                padding: EdgeInsetsGeometry.symmetric(horizontal: 4),
                items: [
                  for (final servico in servicos)
                    DropdownMenuItem(
                      value: servico.id,
                      child: Text(servico.nome),
                    ),
                ],
                onChanged: onServicoChanged,
                validator: (value) =>
                  value == null
                    ? 'Selecione um serviço.'
                    : null,
              ),

              const SizedBox(height: 16),

              Text(
                'Data',
                style: textTheme.labelLarge?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.bold,
                ),
              ),

              // Data
              FormField<DateTime>(
                key: ValueKey(data),
                initialValue: data,
                validator: (_) => data == null
                  ? 'Selecione uma data'
                  : null,
                builder: (field) {
                  return InkWell(
                    onTap: onDataPressed,
                    child: InputDecorator(
                      decoration: InputDecoration(),
                      child: Text(
                        data == null
                          ? 'Selecionar data'
                          : _dateFormatter.dayMonthYear(data!),
                        style: textTheme.bodyLarge,
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 16),

              Text(
                'Horário',
                style: textTheme.labelLarge?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.bold,
                ),
              ),

              // Horário
              FormField<TimeOfDay>(
                key: ValueKey(horario),
                initialValue: horario,
                validator: (_) => horario == null
                  ? 'Selecione um horário'
                  : null,
                builder: (field) {
                  return InkWell(
                    onTap: onHorarioPressed,
                    child: InputDecorator(
                      decoration: InputDecoration(),
                      child: Text(
                        horario?.format(context) ?? 'Selecionar horário',
                        style: textTheme.bodyLarge,
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 16),

              Text(
                'Observações',
                style: textTheme.labelLarge?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.bold,
                ),
              ),

              // Observações
              TextFormField(
                controller: observacoesController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Adicionar observação (opcional)',
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 16),
            ],
          ),

          PrimaryButton(
            label: 'Salvar agendamento',
            onPressed: isLoading ? null : onSubmit,
            isExpanded: true,
          ),
        ],
      ),
    );
  }
}
