import '../../../core/database/database_helper.dart';
import '../domain/cliente.dart';
import '../domain/cliente_atualizacao.dart';
import '../domain/cliente_cadastro.dart';
import '../domain/cliente_repository.dart';
import 'cliente_model.dart';

class ClienteRepositoryImpl implements ClienteRepository {

  const ClienteRepositoryImpl({required this._databaseHelper});

  final DatabaseHelper _databaseHelper;

  static const String clienteTable = 'cliente';

  @override
  buscarPorId(int id) async {
    final db = await _databaseHelper.database;

    final result = await db.query(
      clienteTable,
      columns: ['id', 'nome', 'telefone', 'criado_em', 'ativo'],
      where: 'id = ?',
      whereArgs: [id],
    );

    return result.isNotEmpty
        ? ClienteModel.fromMap(result.first)
        : null;
  }

  @override
  Future<List<Cliente>> buscarTodos() => _buscarClientes(null);

  @override
  Future<List<Cliente>> buscarAtivos() => _buscarClientes(true);

  @override
  Future<List<Cliente>> buscarInativos() => _buscarClientes(false);

  /// Lógica reutilizada de busca do conjunto de clientes,
  /// permitindo filtrar por ativo ou inativo (ou todos),
  /// ordenados por nome.
  Future<List<Cliente>> _buscarClientes(bool? ativo) async {
    final db = await _databaseHelper.database;

    final result =  await db.query(
      clienteTable,
      columns: ['id', 'nome', 'telefone', 'criado_em', 'ativo'],
      where: ativo == null ? null : 'ativo = ?',
      whereArgs: ativo == null ? null : [ativo],
      orderBy: 'nome ASC',
    );

    return [
      for (final row in result)
        ClienteModel.fromMap(row)
    ];
  }

  @override
  Future<int> cadastrar(ClienteCadastro cliente) async {
    final db = await _databaseHelper.database;

    final dados = {
      'nome': cliente.nome,
      'telefone': cliente.telefone,
    };

    return await db.insert(clienteTable, dados);
  }

  @override
  Future<int> atualizar(ClienteAtualizacao cliente) async {
    final db = await _databaseHelper.database;

    return await db.update(
      clienteTable,
      {
        'nome': cliente.nome,
        'telefone': cliente.telefone,
      },
      where: 'id = ?',
      whereArgs: [cliente.id],
    );
  }

  @override
  Future<int> ativar(int id) => _atualizarStatus(id, true);

  @override
  Future<int> desativar(int id) => _atualizarStatus(id, false);

  /// Lógica reutilizada de ativar ou desativar um cliente.
  Future<int> _atualizarStatus(int id, bool ativo) async {
    final db = await _databaseHelper.database;

    return await db.update(
      clienteTable,
      {'ativo': ativo ? 1 : 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}