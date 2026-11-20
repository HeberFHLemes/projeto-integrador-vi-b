import 'relatorio_faturamento.dart';
import 'relatorio_frequencia.dart';

abstract interface class RelatorioRepository {
  Future<RelatorioFaturamento> buscarFaturamento({
    required DateTime inicio,
    required DateTime fim,
  });

  Future<RelatorioFrequencia> buscarFrequencia({
    required DateTime inicio,
    required DateTime fim,
  });
}