import 'package:flutter/material.dart';

class ServicoListTile extends StatelessWidget {

  const ServicoListTile({
    super.key,
    required this.nome,
    required this.preco,
    this.ativo = true,
    required this.onTap,
  });

  final String nome;
  final String preco; // já formatado!
  final bool ativo;
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
      subtitle: Text("Serviço ${ativo ? 'ativo' : 'inativo'}"),
      trailing: Text(
        preco,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      onTap: onTap,
    );
  }
}