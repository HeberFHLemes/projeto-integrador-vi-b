import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import '../../../../app/di/dependencies.dart';
import '../../../../core/ui/app_filter_segmented_button.dart';
import '../../../../core/ui/app_material_banner.dart';
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

  late final TextEditingController _buscaController;

  @override
  void initState() {
    super.initState();

    _buscaController = TextEditingController();

    _viewModel = getIt<ClienteViewModel>();
    _viewModel.carregarClientes();
  }

  @override
  void dispose() {
    _buscaController.dispose();
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, child) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 8,
              children: [
                Text(
                  'Clientes',
                  style: textTheme.headlineSmall,
                ),

                const SizedBox(height: 8),

                Text(
                  'Buscar',
                  style: textTheme.labelLarge?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                // Barra de busca por nome ou telefone
                SearchBar(
                  leading: Icon(
                    Icons.search,
                    color: colorScheme.primary,
                  ),
                  controller: _buscaController,
                  onChanged: _viewModel.filtrarPorTermo,
                  autoFocus: false,
                  hintText: 'Nome ou telefone',
                  side: const WidgetStatePropertyAll(
                    BorderSide(
                      strokeAlign: BorderSide.strokeAlignOutside,
                      color: Colors.black26,
                      style: BorderStyle.solid,
                    ),
                  ),
                  keyboardType: TextInputType.text,
                  elevation: const WidgetStatePropertyAll(0),
                  shape: const WidgetStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      )
                  ),
                ),


                const SizedBox(height: 4),

                // Filtro Ativos/Inativos
                AppFilterSegmentedButton<bool>(
                  segments: const [
                    ButtonSegment<bool>(
                      value: true,
                      label: Text('Ativos'),
                    ),
                    ButtonSegment<bool>(
                      value: false,
                      label: Text('Inativos'),
                    ),
                  ],
                  selected: {_viewModel.mostrarAtivos},
                  onSelectionChanged: (status) {
                    _viewModel.alterarFiltro(status.first);
                  },
                ),

                // Listagem dos clientes
                Expanded(
                  child: _buildContent(),
                ),

                // Botão cadastrar cliente
                PrimaryButton(
                  label: 'Cliente',
                  onPressed: _abrirCadastro,
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
          "$quantidade ${quantidade == 1 ? 'cliente' : 'clientes'}",
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

  // Abre a tela de cadastro e espera o resultado para mostrar ao usuário
  Future<void> _abrirCadastro() async {
    final resultado = await context.pushNamed<bool>(
      RouteNames.cadastroCliente
    );

    if (!mounted) return;

    if (resultado == true) {
      await _viewModel.carregarClientes();

      if (!mounted) return;

      AppMaterialBanner.show(
        context,
        message: 'Cliente cadastrado com sucesso!',
      );
    }
  }
}