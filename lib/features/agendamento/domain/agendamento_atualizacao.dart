class AgendamentoAtualizacao {
  const AgendamentoAtualizacao({
    required this.id,
    required this.clienteId,
    required this.servicoId,
    required this.dataHora,
    this.observacoes,
  });

  final int id;
  final int clienteId;
  final int servicoId;
  final DateTime dataHora;
  final String? observacoes;
}