import '../../../../core/database/database_helper.dart';
import '../domain/relatorio_faturamento.dart';
import '../domain/relatorio_frequencia.dart';
import '../domain/relatorio_repository.dart';
import 'atendimento_relatorio_model.dart';
import 'cliente_frequente_model.dart';

class RelatorioRepositoryImpl implements RelatorioRepository {

  RelatorioRepositoryImpl({required this._databaseHelper});

  final DatabaseHelper _databaseHelper;

  static const String _queryResumoFaturamento = '''
    SELECT
      COALESCE(SUM(valor_cobrado), 0) AS total,
      COUNT(*) AS quantidade
    FROM atendimento
    WHERE realizado_em >= ?
      AND realizado_em < ?
  ''';

  static const String _queryFaturamento = '''
    SELECT
      at.agendamento_id,
      c.nome AS cliente_nome,
      s.nome AS servico_nome,
      at.valor_cobrado,
      at.realizado_em
    FROM atendimento at
    JOIN agendamento a
      ON a.id = at.agendamento_id
    JOIN cliente c
      ON c.id = a.cliente_id
    JOIN servico s
      ON s.id = a.servico_id
    WHERE at.realizado_em >= ?
      AND at.realizado_em < ?
    ORDER BY at.realizado_em DESC
  ''';

  @override
  Future<RelatorioFaturamento> buscarFaturamento({
    required DateTime inicio,
    required DateTime fim
  }) async {

    final inicioPeriodo = _formatarData(inicio);
    final fimPeriodo = _formatarData(
      DateTime(fim.year, fim.month, fim.day + 1),
    );

    final db = await _databaseHelper.database;

    final resultadoResumo = await db.rawQuery(
      _queryResumoFaturamento,
      [inicioPeriodo, fimPeriodo]
    );

    final resumo = resultadoResumo.first;

    final resultadoFaturamento = await db.rawQuery(
      _queryFaturamento,
      [inicioPeriodo, fimPeriodo]
    );

    final atendimentos = resultadoFaturamento
      .map((map) => AtendimentoRelatorioModel.fromMap(map))
      .toList();

    return RelatorioFaturamento(
      total: resumo['total'] as int,
      quantidadeAtendimentos: resumo['quantidade'] as int,
      atendimentos: atendimentos,
    );
  }

  static const String _queryFrequencia = '''
    SELECT
      c.id,
      c.nome,
      COUNT(*) AS quantidade_atendimentos,
      MAX(at.realizado_em) AS ultima_visita
    FROM cliente c
    JOIN agendamento a
      ON a.cliente_id = c.id
    JOIN atendimento at
      ON at.agendamento_id = a.id
    WHERE at.realizado_em >= ?
      AND at.realizado_em < ?
    GROUP BY c.id, c.nome
    ORDER BY
      quantidade_atendimentos DESC,
    ultima_visita DESC
  ''';

  @override
  Future<RelatorioFrequencia>  buscarFrequencia({
    required DateTime inicio,
    required DateTime fim
  }) async {

    final inicioPeriodo = _formatarData(inicio);
    final fimPeriodo = _formatarData(
      DateTime(fim.year, fim.month, fim.day + 1),
    );

    final db = await _databaseHelper.database;

    final resultado = await db.rawQuery(
      _queryFrequencia,
      [inicioPeriodo, fimPeriodo]
    );

    final clientes = resultado
      .map((map) => ClienteFrequenteModel.fromMap(map))
      .toList();

    return RelatorioFrequencia(
      quantidadeClientes: clientes.length,
      clientes: clientes,
    );
  }

  String _formatarData(DateTime data) {
    return data.toUtc().toIso8601String();
  }
}