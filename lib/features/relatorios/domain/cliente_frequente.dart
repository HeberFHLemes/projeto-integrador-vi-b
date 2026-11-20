class ClienteFrequente {

  const ClienteFrequente({
    required this.id,
    required this.nome,
    required this.quantidadeAtendimentos,
    required this.ultimaVisita,
  });

  final int id;
  final String nome;
  final int quantidadeAtendimentos;
  final DateTime ultimaVisita;
}