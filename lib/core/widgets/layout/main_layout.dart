import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/route_names.dart';
import 'logo_app_bar.dart';
import 'navbar.dart';

/// Layout para as telas principais do aplicativo, contendo
/// a AppBar no topo e a barra de navegação ao final da tela.
class MainLayout extends StatelessWidget {

  const MainLayout({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final router = GoRouter.of(context);

    return Scaffold(
      appBar: LogoAppBar(),
      body: child,
      bottomNavigationBar: Navbar(
        destinations: [
          'Agenda',
          'Clientes',
          'Serviços',
          'Relatórios',
        ],
        selectedIndex: _calculateSelectedIndex(context),
        onDestinationSelected: (index) {
          return switch (index) {
            0 => router.goNamed(RouteNames.agenda),
            1 => router.goNamed(RouteNames.clientes),
            2 => router.goNamed(RouteNames.servicos),
            3 => router.goNamed(RouteNames.relatorios),
            _ => router.goNamed(RouteNames.agenda),
          };
        },
      ),
    );
  }

  int _calculateSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;

    if (location.startsWith('/clientes')) return 1;
    if (location.startsWith('/servicos')) return 2;
    if (location.startsWith('/relatorios')) return 3;

    return 0;
  }
}
