import '../../../core/database/database_helper.dart';
import '../domain/servico_cadastro.dart';
import '../domain/servico_repository.dart';
import '../domain/servico.dart';
import 'servico_model.dart';

class ServicoRepositoryImpl implements ServicoRepository {
  const ServicoRepositoryImpl({required this._databaseHelper});

  final DatabaseHelper _databaseHelper;

  static const String servicoTable = 'servico';
  
  @override
  Future<List<Servico>> buscarTodos() async {
    final db = await _databaseHelper.database;

    final result =  await db.query(
      servicoTable,
      columns: ['id', 'nome', 'preco', 'ativo'],
    );

    return [
      for (final row in result)
        ServicoModel.fromMap(row)
    ];
  }
  
  @override
  Future<Servico?> buscarPorId(int id) async {
    final db = await _databaseHelper.database;

    final result = await db.query(
      servicoTable,
      columns: ['id', 'nome', 'preco', 'ativo'],
      where: 'id = ?',
      whereArgs: [id],
    );

    return result.isNotEmpty
      ? ServicoModel.fromMap(result.first)
      : null;
  }

  @override
  Future<int> cadastrar(ServicoCadastro servico) async {
    final db = await _databaseHelper.database;

    final dados = {
      'nome': servico.nome,
      'telefone': servico.preco,
    };

    return await db.insert(servicoTable, dados);
  }

  @override
  Future<int> ativar(int id) async {
    final db = await _databaseHelper.database;

    return await db.update(
      servicoTable,
      {'ativo': 1},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
  
  @override
  Future<int> desativar(int id) async {
    final db = await _databaseHelper.database;

    return await db.update(
      servicoTable,
      {'ativo': 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}