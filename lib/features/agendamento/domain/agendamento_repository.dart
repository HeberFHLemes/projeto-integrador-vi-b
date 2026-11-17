import 'agendamento.dart';
import 'agendamento_atualizacao.dart';
import 'agendamento_cadastro.dart';

abstract interface class AgendamentoRepository {

  Future<List<Agendamento>> buscarTodos();

  Future<Agendamento?> buscarPorId(int id);

  Future<List<Agendamento>> buscarPorCliente(int clienteId);

  Future<List<Agendamento>> buscarPorServico(int servicoId);

  Future<List<Agendamento>> buscarPorDia(DateTime dia);

  Future<List<Agendamento>> buscarRealizadosPorPeriodo({
    required DateTime inicio,
    required DateTime fim,
  });

  Future<int> cadastrar(AgendamentoCadastro agendamento);

  Future<int> atualizar(AgendamentoAtualizacao agendamento);

  Future<int> remover(int id);

  Future<void> marcarComoRealizado(int id);

  Future<void> desmarcarComoRealizado(int id);

  Future<bool> foiRealizado(int id);
}