class AgendamentoCadastro {
  const AgendamentoCadastro({
    required this.clienteId,
    required this.servicoId,
    required this.dataHora,
    this.observacoes,
  });

  final int clienteId;
  final int servicoId;
  final DateTime dataHora;
  final String? observacoes;
}