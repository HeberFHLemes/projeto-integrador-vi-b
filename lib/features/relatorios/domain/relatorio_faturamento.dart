import 'atendimento_relatorio.dart';

class RelatorioFaturamento {

  const RelatorioFaturamento({
    required this.total,
    required this.quantidadeAtendimentos,
    required this.atendimentos,
  });

  final int total;
  final int quantidadeAtendimentos;
  final List<AtendimentoRelatorio> atendimentos;
}
