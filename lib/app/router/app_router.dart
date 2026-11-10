import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/widgets/layout/main_layout.dart';
import '../../features/agendamento/presentation/pages/agenda_page.dart';
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
