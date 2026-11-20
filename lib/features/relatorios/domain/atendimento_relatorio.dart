class AtendimentoRelatorio {

  const AtendimentoRelatorio({
    required this.agendamentoId,
    required this.clienteNome,
    required this.servicoNome,
    required this.valorCobrado,
    required this.realizadoEm,
  });

  final int agendamentoId;
  final String clienteNome;
  final String servicoNome;
  final int valorCobrado;
  final DateTime realizadoEm;
}