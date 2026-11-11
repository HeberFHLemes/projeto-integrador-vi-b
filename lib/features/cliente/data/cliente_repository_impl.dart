import '../../../core/database/database_helper.dart';
import '../domain/cliente.dart';
import '../domain/cliente_cadastro.dart';
import '../domain/cliente_repository.dart';
import 'cliente_model.dart';

class ClienteRepositoryImpl implements ClienteRepository {

  const ClienteRepositoryImpl({required this._databaseHelper});

  final DatabaseHelper _databaseHelper;

  static const String clienteTable = 'cliente';

  @override
  Future<List<Cliente>> buscarTodos() async {
    final db = await _databaseHelper.database;

    final result =  await db.query(
      clienteTable,
      columns: ['id', 'nome', 'telefone', 'criado_em', 'ativo'],
    );

    return [
      for (final row in result)
        ClienteModel.fromMap(row)
    ];
  }

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
  Future<int> cadastrar(ClienteCadastro cliente) async {
    final db = await _databaseHelper.database;

    final dados = {
      'nome': cliente.nome,
      'telefone': cliente.telefone,
    };

    return await db.insert(clienteTable, dados);
  }

  @override
  Future<int> ativar(int id) async {
    final db = await _databaseHelper.database;

    return await db.update(
      clienteTable,
      {'ativo': 1},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<int> desativar(int id) async {
    final db = await _databaseHelper.database;

    return await db.update(
      clienteTable,
      {'ativo': 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}