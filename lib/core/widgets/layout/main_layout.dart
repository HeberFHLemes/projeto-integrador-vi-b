import 'package:flutter/material.dart';

import 'logo_app_bar.dart';

class MainLayout extends StatelessWidget {

  const MainLayout({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: LogoAppBar(),
      body: child,
      // TODO: bottomNavigationBar
    );
  }
}
