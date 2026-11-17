/// Entidade que representa a realização de um agendamento.
class Atendimento {
  const Atendimento({
    required this.agendamentoId,
    required this.valorCobrado,
    required this.realizadoEm,
  });

  final int agendamentoId;
  final int valorCobrado;
  final DateTime realizadoEm;
  // (atributo não utilizado na aplicação)
  // final DateTime registradoEm;
}