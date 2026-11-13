import 'servico_atualizacao.dart';
import 'servico_cadastro.dart';
import 'servico.dart';

abstract interface class ServicoRepository {
  Future<List<Servico>> buscarTodos();

  Future<Servico?> buscarPorId(int id);

  Future<List<Servico>> buscarAtivos();

  Future<List<Servico>> buscarInativos();

  Future<int> cadastrar(ServicoCadastro servico);

  Future<int> atualizar(ServicoAtualizacao servico);

  Future<int> ativar(int id);

  Future<int> desativar(int id);
}