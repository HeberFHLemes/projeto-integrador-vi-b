import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/route_names.dart';

class LogoAppBar extends StatelessWidget implements PreferredSizeWidget {
  const LogoAppBar({super.key});

  final String _logoPath = 'assets/images/logo_horizontal.png';

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          IconButton(
            onPressed: () => context.go('/'),
            icon: Image.asset(
              _logoPath,
              fit: BoxFit.contain,
              height: 48
            ),
          ),
        ],
      ),
      actionsPadding: EdgeInsetsGeometry.symmetric(horizontal: 8),
      actions: [
        TextButton(
          onPressed: () => context.pushNamed(RouteNames.sobre),
          child: Text(
            'Sobre',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.bold,
            )
          ),
        )
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}