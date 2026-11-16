import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import '../../../../app/di/dependencies.dart';
import '../../../../core/ui/app_material_banner.dart';
import '../../../../core/utils/phone_number_utils.dart';
import '../../../../core/ui/layouts/secondary_layout.dart';
import '../../../../core/ui/primary_button.dart';
import '../../../../core/ui/secondary_button.dart';
import '../../domain/cliente.dart';
import '../viewmodels/ficha_cliente_view_model.dart';

class FichaClientePage extends StatefulWidget {
  const FichaClientePage({super.key, required this.id});

  final int id;

  @override
  State<StatefulWidget> createState() => _FichaClientePageState();
}

class _FichaClientePageState extends State<FichaClientePage> {
  late final FichaClienteViewModel _viewModel;

  late final int clienteId;

  @override
  void initState() {
    super.initState();

    clienteId = widget.id;

    _viewModel = getIt<FichaClienteViewModel>();
    _viewModel.buscarCliente(clienteId);
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

        final cliente = _viewModel.cliente!;

        return _buildDetalhes(cliente);
      },
    );
  }

  Widget _buildDetalhes(Cliente cliente) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return SecondaryLayout(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              spacing: 8,
              children: [
                Text(
                  'Ficha do cliente',
                  style: textTheme.headlineSmall,
                ),

                // Card do cliente
                SizedBox(
                  width: double.maxFinite,
                  child: Card(
                    elevation: 0,
                    color: colorScheme.secondary,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Cliente ${cliente.ativo ? 'ativo' : 'inativo'}',
                            style: textTheme.labelLarge?.copyWith(
                              color: colorScheme.primary,
                            ),
                          ),

                          Text(
                            cliente.nome,
                            style: textTheme.headlineSmall,
                          ),

                          Text(
                            PhoneNumberUtils.format(cliente.telefone),
                            style: textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Botão editar cliente
                SecondaryButton(
                  label: 'Editar cliente',
                  onPressed: _abrirAtualizacao,
                  isExpanded: true,
                ),

                // Seção com os agendamentos do cliente
                Text(
                  'Histórico de agendamentos',
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                // TODO: Listagem dos agendamentos relacionados ao cliente.
              ],
            ),
          ),

          // Redirecionar para novo agendamento, com o cliente escolhido.
          PrimaryButton(
            label: 'Agendar para este cliente',
            onPressed: () => context.goNamed(
              RouteNames.novoAgendamento,
              pathParameters: { 'id': cliente.id.toString() }
            ),
            isExpanded: true,
          ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }

  void _abrirAtualizacao() async {
    final resultado = await context.pushNamed<bool>(
      RouteNames.atualizacaoCliente,
      pathParameters: { 'id': clienteId.toString() }
    );

    if (!mounted) return;

    if (resultado == true) {
      await _viewModel.buscarCliente(clienteId);

      if (!mounted) return;

      AppMaterialBanner.show(
        context,
        message: 'Cliente atualizado com sucesso!',
      );
    }
  }
}
