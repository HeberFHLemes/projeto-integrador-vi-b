import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/di/dependencies.dart';
import '../../../../app/router/route_names.dart';
import '../../../../core/utils/money_formatter.dart';
import '../../../../core/ui/app_filter_segmented_button.dart';
import '../../../../core/ui/app_material_banner.dart';
import '../../../../core/ui/primary_button.dart';
import '../viewmodels/servicos_view_model.dart';
import '../widgets/servico_list_tile.dart';

class ServicosPage extends StatefulWidget {
  const ServicosPage({super.key});

  @override
  State<StatefulWidget> createState() => _ServicosPageState();
}

class _ServicosPageState extends State<ServicosPage> {
  late final ServicosViewModel _viewModel;

  late final MoneyFormatter _moneyFormatter;

  @override
  void initState() {
    super.initState();

    _moneyFormatter = MoneyFormatter();

    _viewModel = getIt<ServicosViewModel>();
    _viewModel.carregarServicos();
  }

  @override
  void dispose() {
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
                  'Serviços',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),

                const SizedBox(height: 8),

                Text(
                  'Buscar',
                  style: textTheme.labelLarge?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SearchBar(
                  // TODO: filtro de busca por nome
                  autoFocus: false,
                  hintText: 'Nome do serviço',
                  side: WidgetStatePropertyAll(
                    BorderSide(
                      strokeAlign: BorderSide.strokeAlignOutside,
                      color: Colors.black26,
                      style: BorderStyle.solid,
                    ),
                  ),
                  keyboardType: TextInputType.text,
                  elevation: WidgetStatePropertyAll(0),
                  shape: WidgetStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    )
                  ),
                  onChanged: (nome) {} // TODO,
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

                // Listagem dos serviços
                Expanded(
                  child: _montarConteudo(),
                ),

                // Botão cadastrar serviço
                PrimaryButton(
                  label: 'Serviço',
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

  // Abre a tela de cadastro e espera o resultado para mostrar ao usuário
  Future<void> _abrirCadastro() async {
    final resultado = await context.pushNamed<bool>(
      RouteNames.cadastroServico
    );

    if (!mounted) return;

    if (resultado == true) {
      await _viewModel.carregarServicos();

      if (!mounted) return;

      AppMaterialBanner.show(
        context,
        message: 'Serviço cadastrado com sucesso!',
      );
    }
  }

  // Abre a tela de edição e espera o resultado para mostrar ao usuário
  Future<void> _abrirAtualizacao(int idServico) async {
    final resultado = await context.pushNamed<bool>(
        RouteNames.atualizacaoServico,
        pathParameters: { 'id': idServico.toString() }
    );

    if (!mounted) return;

    if (resultado == true) {
      await _viewModel.carregarServicos();

      if (!mounted) return;

      // Sem diferenciar se foi alteração dos campos
      // nome e preço ou de status (ativo / inativo).
      AppMaterialBanner.show(
        context,
        message: 'Serviço atualizado com sucesso!',
      );
    }
  }

  Widget _montarConteudo() {
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

    if (_viewModel.servicos.isEmpty) {
      return const Center(
        child: Text('Nenhum serviço encontrado.'),
      );
    }

    final quantidade = _viewModel.servicos.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$quantidade serviços',
          style: Theme.of(context).textTheme.labelMedium,
        ),

        const SizedBox(height: 12),

        Expanded(
          child: ListView.separated(
            itemCount: quantidade,
            itemBuilder: (context, index) {
              final servico = _viewModel.servicos[index];

              return ServicoListTile(
                nome: servico.nome,
                preco: _moneyFormatter.format(servico.preco),
                // redireciona direto para tela de atualização do serviço
                onTap: () => _abrirAtualizacao(servico.id),
              );
            },
            separatorBuilder: (_, _) => const Divider(thickness: 0.2),
          ),
        ),
      ],
    );
  }
}
