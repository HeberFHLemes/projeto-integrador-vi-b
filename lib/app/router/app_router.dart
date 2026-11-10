import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/agendamento/presentation/pages/agenda_page.dart';
import 'route_names.dart';

GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey();

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  navigatorKey: rootNavigatorKey,
  routes: [
    GoRoute(
      path: '/',
      name: RouteNames.agenda,
      builder: (context, state) {
        return Scaffold(
            body: const AgendaPage(),
        );
      }
    ),
  ],
);
