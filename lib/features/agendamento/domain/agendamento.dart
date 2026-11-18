import 'atendimento.dart';
import '../../cliente/domain/cliente.dart';
import '../../servicos/domain/servico.dart';

enum StatusAgendamento {
  agendado,
  naoRealizado,
  realizado;
}

/// Entidade Agendamento completa, com seus relacionamentos.
class Agendamento {
  const Agendamento({
    required this.id,
    required this.cliente,
    required this.servico,
    required this.dataHora,
    this.observacoes,
    required this.criadoEm,
    this.atendimento,
  });

  final int id;

  // Entidades, em vez de só os ids
  final Cliente cliente;
  final Servico servico;

  final DateTime dataHora;
  final String? observacoes;
  final DateTime criadoEm;

  // Se realizado, traz os dados do atendimento. Se não, null.
  final Atendimento? atendimento;

  // getters com as regras de negócio da entidade
  bool get realizado => atendimento != null;

  int get valorTotal => atendimento?.valorCobrado ?? servico.preco;

  StatusAgendamento get status {
    if (realizado) {
      return StatusAgendamento.realizado;
    }

    if (dataHora.isBefore(DateTime.now())) {
      return StatusAgendamento.naoRealizado;
    }

    return StatusAgendamento.agendado;
  }
}
