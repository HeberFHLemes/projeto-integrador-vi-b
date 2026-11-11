import 'cliente_atualizacao.dart';
import 'cliente_cadastro.dart';
import 'cliente.dart';

abstract interface class ClienteRepository {
  Future<List<Cliente>> buscarTodos();

  Future<Cliente?> buscarPorId(int id);

  Future<List<Cliente>> buscarAtivos();

  Future<List<Cliente>> buscarInativos();

  Future<int> cadastrar(ClienteCadastro cliente);

  Future<int> atualizar(ClienteAtualizacao cliente);

  Future<int> ativar(int id);

  Future<int> desativar(int id);
}