import '../domain/atendimento_relatorio.dart';

class AtendimentoRelatorioModel extends AtendimentoRelatorio {

  const AtendimentoRelatorioModel({
    required super.agendamentoId,
    required super.clienteNome,
    required super.servicoNome,
    required super.valorCobrado,
    required super.realizadoEm,
  });

  factory AtendimentoRelatorioModel.fromMap(Map<String, Object?> map) {
    return AtendimentoRelatorioModel(
      agendamentoId: map['agendamento_id'] as int,
      clienteNome: map['cliente_nome'] as String,
      servicoNome: map['servico_nome'] as String,
      valorCobrado: map['valor_cobrado'] as int,
      realizadoEm: DateTime.parse(map['realizado_em'] as String),
    );
  }
}