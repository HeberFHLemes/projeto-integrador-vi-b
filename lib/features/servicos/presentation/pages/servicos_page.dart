import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/di/dependencies.dart';
import '../../../../app/router/route_names.dart';
import '../../../../core/utils/money_formatter.dart';
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
                  'Serviços',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),

                // TODO: filtro de busca por nome

                // TODO: Seletor do filtro ativos/inativos

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
          '$quantidade servicos',
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
                onTap: () => context.goNamed(
                  // redireciona direto para tela de atualização do serviço
                  RouteNames.atualizacaoServico,
                  pathParameters: { 'id': servico.id.toString() }
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
