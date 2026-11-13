import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/ui/layouts/main_layout.dart';
import '../../features/agendamento/presentation/pages/agenda_page.dart';
import '../../features/cliente/presentation/pages/cliente_page.dart';
import '../../features/relatorios/presentation/pages/relatorios_page.dart';
import '../../features/servicos/presentation/pages/atualizacao_servico_page.dart';
import '../../features/servicos/presentation/pages/cadastro_servico_page.dart';
import '../../features/servicos/presentation/pages/servicos_page.dart';
import '../../features/sobre/sobre_page.dart';
import 'route_names.dart';

GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey();
GlobalKey<NavigatorState> shellNavigatorKey = GlobalKey();

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  navigatorKey: rootNavigatorKey,
  routes: [
    ShellRoute(
      navigatorKey: shellNavigatorKey,
      builder: (context, state, child) => MainLayout(child: child),
      routes: [
        // Agenda (tela inicial)
        GoRoute(
          path: '/',
          name: RouteNames.agenda,
          builder: (context, state) => const AgendaPage(),
          routes: [
            // rotas sem o mesmo layout
            // (rootNavigatorKey como parentNavigatorKey)
            /*
              TODO:
                - tela para novo agendamento
                - tela para consultar detalhes de um agendamento
                - tela para editar um agendamento
             */
          ],
        ),

        // Clientes
        GoRoute(
          path: '/clientes',
          name: RouteNames.clientes,
          builder: (context, state) => ClientePage(),
          routes: [
            /*
              TODO:
                - tela para cadastro de novo cliente
                - tela para consultar ficha de um cliente
                - tela para editar dados de um cliente
             */
          ],
        ),

        // Relatórios
        GoRoute(
          path: '/relatorios',
          name: RouteNames.relatorios,
          builder: (context, state) => const RelatoriosPage(),
        ),

        // Serviços
        GoRoute(
          path: '/servicos',
          name: RouteNames.servicos,
          builder: (context, state) => const ServicosPage(),
          routes: [
            GoRoute(
              path: 'cadastro',
              name: RouteNames.cadastroServico,
              parentNavigatorKey: rootNavigatorKey,
              builder: (context, state) => const CadastroServicoPage(),
            ),

            GoRoute(
              path: ':id',
              name: RouteNames.atualizacaoServico,
              parentNavigatorKey: rootNavigatorKey,
              builder: (context, state) {
                final id = int.tryParse(
                  state.pathParameters['id'] ?? '',
                );

                if (id == null || id <= 0) {
                  // TODO: informar página não encontrada / id inválido
                  throw const FormatException('ID do serviço inválido');
                }

                return AtualizacaoServicoPage(
                  key: ValueKey(id),
                  id: id,
                );
              },
            )
          ],
        ),
      ],
    ),

    // Sobre
    GoRoute(
      path: '/sobre',
      name: RouteNames.sobre,
      builder: (_, _) => const SobrePage(),
    ),
  ],
);
