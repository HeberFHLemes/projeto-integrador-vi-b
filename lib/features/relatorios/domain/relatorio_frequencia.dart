import 'cliente_frequente.dart';

class RelatorioFrequencia {

  const RelatorioFrequencia({
    required this.quantidadeClientes,
    required this.clientes,
  });

  final int quantidadeClientes;
  final List<ClienteFrequente> clientes;
}