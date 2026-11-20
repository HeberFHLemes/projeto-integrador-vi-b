import '../../../core/database/database_helper.dart';
import '../domain/agendamento.dart';
import '../domain/agendamento_atualizacao.dart';
import '../domain/agendamento_cadastro.dart';
import '../domain/agendamento_repository.dart';
import 'agendamento_model.dart';

class AgendamentoRepositoryImpl implements AgendamentoRepository {

  const AgendamentoRepositoryImpl({required this._databaseHelper});

  final DatabaseHelper _databaseHelper;

  static const String agendamentoTable = 'agendamento';

  static const String atendimentoTable = 'atendimento';

  static const String _selectAgendamentoCompleto = '''
    SELECT
      a.id, a.data_hora, a.observacoes, a.criado_em,
      c.id AS cliente_id,
      c.nome AS cliente_nome,
      c.telefone AS cliente_telefone,
      c.criado_em AS cliente_criado_em,
      c.ativo AS cliente_ativo,
      s.id AS servico_id,
      s.nome AS servico_nome,
      s.preco AS servico_preco,
      s.ativo AS servico_ativo,
      at.agendamento_id AS atendimento_agendamento_id,
      at.valor_cobrado AS atendimento_valor_cobrado,
      at.realizado_em AS atendimento_realizado_em 
    FROM agendamento a
    JOIN cliente c ON c.id = a.cliente_id
    JOIN servico s ON s.id = a.servico_id
    LEFT JOIN atendimento at ON at.agendamento_id = a.id
  ''';

  /// Consulta todos os agendamentos registrados.
  @override
  Future<List<Agendamento>> buscarTodos() async {
    final db = await _databaseHelper.database;

    final result =  await db.rawQuery(_selectAgendamentoCompleto);

    return [
      for (final row in result)
        AgendamentoModel.fromMap(row)
    ];
  }

  /// Busca um agendamento pelo seu ID.
  @override
  Future<Agendamento?> buscarPorId(int id) async {
    final db = await _databaseHelper.database;

    final sql = "$_selectAgendamentoCompleto WHERE a.id = ?";

    final result =  await db.rawQuery(sql, [id]);

    return result.isEmpty
      ? null
      : AgendamentoModel.fromMap(result.first);
  }

  /// Busca os agendamentos de um determinado dia
  @override
  Future<List<Agendamento>> buscarPorDia(DateTime dia) async {
    final inicio = DateTime(dia.year, dia.month, dia.day);

    final fim = DateTime(dia.year, dia.month, dia.day + 1);

    return buscarRealizadosPorPeriodo(
      inicio: inicio,
      fim: fim
    );
  }

  /// Busca os agendamentos de um determinado período
  @override
  Future<List<Agendamento>> buscarRealizadosPorPeriodo({
    required DateTime inicio,
    required DateTime fim,
  }) async {
    final db = await _databaseHelper.database;

    final result = await db.rawQuery('''
      $_selectAgendamentoCompleto
      WHERE a.data_hora >= ?
        AND a.data_hora < ?
      ORDER BY a.data_hora ASC
    ''',
      [
        inicio.toUtc().toIso8601String(),
        fim.toUtc().toIso8601String(),
      ],
    );

    return result.map(AgendamentoModel.fromMap).toList();
  }

  /// Busca todos os agendamentos referentes a um cliente.
  @override
  Future<List<Agendamento>> buscarPorCliente(int clienteId) async {
    final db = await _databaseHelper.database;

    final sql = "$_selectAgendamentoCompleto WHERE c.id = ?";

    final result =  await db.rawQuery(sql, [clienteId]);

    return [
      for (final row in result)
        AgendamentoModel.fromMap(row)
    ];
  }

  /// Busca todos os agendamentos referentes a um serviço.
  @override
  Future<List<Agendamento>> buscarPorServico(int servicoId) async {
    final db = await _databaseHelper.database;

    final sql = "$_selectAgendamentoCompleto WHERE s.id = ?";

    final result =  await db.rawQuery(sql, [servicoId]);

    return [
      for (final row in result)
        AgendamentoModel.fromMap(row)
    ];
  }

  /// Atualiza os dados de um agendamento, se não tiver sido realizado.
  @override
  Future<int> atualizar(AgendamentoAtualizacao agendamento) async {
    final db = await _databaseHelper.database;

    final realizado = await foiRealizado(agendamento.id);

    if (realizado) {
      throw Exception('Agendamento já realizado');
    }

    return await db.update(
      agendamentoTable,
      {
        'cliente_id': agendamento.clienteId,
        'servico_id': agendamento.servicoId,
        'data_hora': agendamento.dataHora.toUtc().toIso8601String(),
        'observacoes': agendamento.observacoes,
      },
      where: '''
        id = ?
        AND id NOT IN (
          SELECT agendamento_id FROM Atendimento
        )
      ''',
      whereArgs: [agendamento.id],
    );
  }

  /// Registra um novo agendamento.
  @override
  Future<int> cadastrar(AgendamentoCadastro cadastro) async {
    final db = await _databaseHelper.database;

    return db.insert(agendamentoTable, {
      'cliente_id': cadastro.clienteId,
      'servico_id': cadastro.servicoId,
      'data_hora': cadastro.dataHora.toUtc().toIso8601String(),
      'observacoes': cadastro.observacoes,
    });
  }

  /// Verifica se o agendamento foi realizado ou não
  @override
  Future<bool> foiRealizado(int id) async {
    final db = await _databaseHelper.database;

    final result = await db.rawQuery(
      'SELECT 1 FROM $atendimentoTable WHERE agendamento_id = ?',
      [id],
    );

    return result.isNotEmpty;
  }

  /// Marca um agendamento como realizado (registra um atendimento).
  @override
  Future<void> marcarComoRealizado(int id) async {
    final db = await _databaseHelper.database;

    await db.transaction((txn) async {
      final result = await txn.rawQuery('''
      SELECT
        a.id,
        a.data_hora,
        s.preco
      FROM agendamento a
      JOIN servico s ON s.id = a.servico_id
      WHERE a.id = ?
    ''', [id]);

      if (result.isEmpty) {
        throw Exception('Agendamento não encontrado.');
      }

      final agendamento = result.first;

      final atendimentoExistente = await txn.query(
        'atendimento',
        where: 'agendamento_id = ?',
        whereArgs: [id],
      );

      if (atendimentoExistente.isNotEmpty) {
        throw Exception('Agendamento já realizado.');
      }

      await txn.insert(atendimentoTable, {
        'agendamento_id': id,
        'valor_cobrado': agendamento['preco'],
        'realizado_em': agendamento['data_hora'],
      });
    });
  }

  /// Marca um agendamento como não realizado,
  /// isto é, remove o registro de seu atendimento.
  @override
  Future<void> desmarcarComoRealizado(int id) async {
    if (!(await foiRealizado(id))) {
      throw Exception('Agendamento não foi realizado.');
    }

    final db = await _databaseHelper.database;

    final result = await db.delete(
      atendimentoTable,
      where: 'agendamento_id = ?',
      whereArgs: [id],
    );

    if (result < 1) {
      throw Exception('Não foi possível marcar como não realizado.');
    }
  }

  /// Remove um agendamento, quando este não foi realizado ainda.
  @override
  Future<int> remover(int id) async {
    if (await foiRealizado(id)) {
      throw Exception('Agendamento já foi realizado.');
    }

    final db = await _databaseHelper.database;

    final result = await db.delete(
      agendamentoTable,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (result < 1) {
      throw Exception('Não foi possível remover o agendamento.');
    }

    return result;
  }
}