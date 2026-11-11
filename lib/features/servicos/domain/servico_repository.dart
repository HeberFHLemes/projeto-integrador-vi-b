import 'servico_cadastro.dart';
import 'servico.dart';

abstract interface class ServicoRepository {
  Future<List<Servico>> buscarTodos();

  Future<Servico?> buscarPorId(int id);

  Future<int> cadastrar(ServicoCadastro cliente);

  Future<int> ativar(int id);

  Future<int> desativar(int id);
}