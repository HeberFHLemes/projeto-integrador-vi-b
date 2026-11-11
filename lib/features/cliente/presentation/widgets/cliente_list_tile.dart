import 'package:flutter/material.dart';

class ClienteListTile extends StatelessWidget {

  const ClienteListTile({
    super.key,
    required this.nome,
    required this.telefone,
    required this.onTap,
  });

  final String nome;
  final String telefone;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsetsGeometry.symmetric(horizontal: 4),
      title: Text(
        nome,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.bold
        ),
      ),
      subtitle: Text(telefone),
      trailing: Icon(
        Icons.chevron_right,
        color: Theme.of(context).colorScheme.primary,
      ),
      onTap: onTap,
    );
  }
}