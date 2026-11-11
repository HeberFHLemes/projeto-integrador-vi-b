import 'cliente_cadastro.dart';
import 'cliente.dart';

abstract interface class ClienteRepository {
  Future<List<Cliente>> buscarTodos();

  Future<Cliente?> buscarPorId(int id);

  Future<int> cadastrar(ClienteCadastro cliente);

  Future<int> ativar(int id);

  Future<int> desativar(int id);
}