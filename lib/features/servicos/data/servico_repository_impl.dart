import '../../../core/database/database_helper.dart';
import '../domain/servico_atualizacao.dart';
import '../domain/servico_cadastro.dart';
import '../domain/servico_repository.dart';
import '../domain/servico.dart';
import 'servico_model.dart';

class ServicoRepositoryImpl implements ServicoRepository {
  const ServicoRepositoryImpl({required this._databaseHelper});

  final DatabaseHelper _databaseHelper;

  static const String servicoTable = 'servico';
  
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
  Future<List<Servico>> buscarTodos() => _buscarServico(null);

  @override
  Future<List<Servico>> buscarAtivos() => _buscarServico(true);

  @override
  Future<List<Servico>> buscarInativos() => _buscarServico(false);

  /// Lógica reutilizada de busca do conjunto de serviços,
  /// permitindo filtrar por ativo, inativo ou todos),
  /// ordenados por nome.
  Future<List<Servico>> _buscarServico(bool? ativo) async {
    final db = await _databaseHelper.database;

    final result =  await db.query(
      servicoTable,
      columns: ['id', 'nome', 'preco', 'ativo'],
      where: ativo == null ? null : 'ativo = ?',
      whereArgs: ativo == null ? null : [ativo],
      orderBy: 'nome ASC',
    );

    return [
      for (final row in result)
        ServicoModel.fromMap(row)
    ];
  }

  @override
  Future<int> cadastrar(ServicoCadastro servico) async {
    final db = await _databaseHelper.database;

    final dados = {
      'nome': servico.nome,
      'preco': servico.preco,
    };

    return await db.insert(servicoTable, dados);
  }

  /// Lógica reutilizada de ativar ou desativar um serviço.
  Future<int> _atualizarStatus(int id, bool ativo) async {
    final db = await _databaseHelper.database;

    return await db.update(
      servicoTable,
      {'ativo': ativo ? 1 : 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<int> ativar(int id) => _atualizarStatus(id, true);
  
  @override
  Future<int> desativar(int id) => _atualizarStatus(id, false);

  @override
  Future<int> atualizar(ServicoAtualizacao servico) async {
    final db = await _databaseHelper.database;

    return await db.update(
      servicoTable,
      {
        'nome': servico.nome,
        'preco': servico.preco,
      },
      where: 'id = ?',
      whereArgs: [servico.id],
    );
  }
}