import '../../cliente/data/cliente_model.dart';
import '../../servicos/data/servico_model.dart';
import '../domain/agendamento.dart';
import '../domain/atendimento.dart';

class AgendamentoModel extends Agendamento {
  AgendamentoModel({
    required super.id,
    required super.cliente,
    required super.servico,
    required super.dataHora,
    super.observacoes,
    required super.criadoEm,
    super.atendimento,
  });

  factory AgendamentoModel.fromMap(Map<String, Object?> map) {
    final atendimentoId = map['atendimento_agendamento_id'] as int?;

    return AgendamentoModel(
      id: map['id'] as int,
      cliente: ClienteModel.fromMap({
        'id': map['cliente_id'],
        'nome': map['cliente_nome'],
        'telefone': map['cliente_telefone'],
        'criado_em': map['cliente_criado_em'],
        'ativo': map['cliente_ativo'],
      }),
      servico: ServicoModel.fromMap({
        'id': map['servico_id'],
        'nome': map['servico_nome'],
        'preco': map['servico_preco'],
        'ativo': map['servico_ativo'],
      }),
      dataHora: DateTime.parse(map['data_hora'] as String),
      observacoes: map['observacoes'] as String?,
      criadoEm: DateTime.parse(map['criado_em'] as String),
      atendimento: atendimentoId == null
        ? null
        : Atendimento(
          agendamentoId: atendimentoId,
          valorCobrado: map['atendimento_valor_cobrado'] as int,
          realizadoEm: DateTime.parse(
            map['atendimento_realizado_em'] as String,
          ),
      ),
    );
  }
}
