import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import '../../../../app/di/dependencies.dart';
import '../../../../core/ui/primary_button.dart';
import '../viewmodels/cliente_view_model.dart';
import '../widgets/cliente_list_tile.dart';

class ClientePage extends StatefulWidget {
  const ClientePage({super.key});

  @override
  State<ClientePage> createState() => _ClientePageState();
}

class _ClientePageState extends State<ClientePage> {
  late final ClienteViewModel _viewModel;

  @override
  void initState() {
    super.initState();

    _viewModel = getIt<ClienteViewModel>();
    _viewModel.carregarClientes();
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
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 4,
              children: [
                Text(
                  'Clientes',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),

                // TODO: filtro de busca por nome ou telefone

                // TODO: Seletor do filtro ativos/inativos

                // Listagem dos clientes
                Expanded(
                  child: _buildContent(),
                ),

                // Botão cadastrar cliente
                PrimaryButton(
                  label: 'Cliente',
                  onPressed: () => context.pushNamed(
                    RouteNames.cadastroCliente
                  ),
                  icon: Icons.add,
                  isExpanded: true,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildContent() {
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

    if (_viewModel.clientes.isEmpty) {
      return const Center(
        child: Text('Nenhum cliente encontrado.'),
      );
    }

    final quantidade = _viewModel.clientes.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$quantidade clientes',
          style: Theme.of(context).textTheme.labelMedium,
        ),

        const SizedBox(height: 12),

        Expanded(
          child: ListView.separated(
            itemCount: quantidade,
            itemBuilder: (context, index) {
              final cliente = _viewModel.clientes[index];

              return ClienteListTile(
                nome: cliente.nome,
                telefone: cliente.telefone,
                onTap: () => context.goNamed(
                  RouteNames.fichaCliente,
                  pathParameters: { 'id': cliente.id.toString() }
                ),
              );
            },
            separatorBuilder: (_, _) => const Divider(thickness: 0.2),
          ),
        ),
      ],
    );
  }
}