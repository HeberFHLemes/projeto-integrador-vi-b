import 'package:flutter/material.dart';

enum OpcaoContato {
  whatsapp,
  tel,
}

/// Componente para apresentar ao usuário as opções disponíveis
/// de aplicações para abrir o contato do cliente.
class OpcoesContatoSheet extends StatelessWidget {

  const OpcoesContatoSheet({super.key});

  static Future<OpcaoContato?> show(BuildContext context) {
    return showModalBottomSheet<OpcaoContato>(
      context: context,
      builder: (_) => const OpcoesContatoSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(
                'Como deseja entrar em contato?',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            ListTile(
              leading: const Icon(Icons.chat),
              title: const Text('WhatsApp'),
              onTap: () => Navigator.pop<OpcaoContato>(
                context,
                OpcaoContato.whatsapp,
              ),
            ),
            ListTile(
              leading: const Icon(Icons.phone),
              title: const Text('Telefone'),
              onTap: () => Navigator.pop<OpcaoContato>(
                context,
                OpcaoContato.tel,
              ),
            ),

            const Divider(height: 8),

            ListTile(
              leading: Icon(
                Icons.close,
                color: colorScheme.onSurfaceVariant,
              ),
              title: const Text('Cancelar'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}