import 'package:flutter/material.dart';

import '../../domain/relatorio_faturamento.dart';
import '../../domain/relatorio_frequencia.dart';
import '../../domain/relatorio_repository.dart';

enum TipoRelatorio {
  faturamento,
  frequencia,
}

class RelatoriosViewModel extends ChangeNotifier {

  RelatoriosViewModel({
    required this._repository,
  }) {
    final agora = DateTime.now();

    inicio = DateTime(agora.year, agora.month, 1);
    fim = DateTime(agora.year, agora.month + 1, 0);
  }

  final RelatorioRepository _repository;

  TipoRelatorio _tipoRelatorio = TipoRelatorio.faturamento;
  TipoRelatorio get tipoRelatorio => _tipoRelatorio;

  late DateTime inicio;
  late DateTime fim;

  RelatorioFaturamento? _relatorioFaturamento;
  RelatorioFaturamento? get relatorioFaturamento => _relatorioFaturamento;

  RelatorioFrequencia? _relatorioFrequencia;
  RelatorioFrequencia? get relatorioFrequencia => _relatorioFrequencia;

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  String? errorMessage;

  Future<void> carregarRelatorio() async {
    _isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      switch (_tipoRelatorio) {
        case TipoRelatorio.faturamento:
          _relatorioFaturamento = await _repository.buscarFaturamento(
            inicio: inicio,
            fim: fim,
          );

        case TipoRelatorio.frequencia:
          _relatorioFrequencia = await _repository.buscarFrequencia(
            inicio: inicio,
            fim: fim,
          );
      }
    } catch (e) {
      errorMessage = 'Não foi possível carregar os dados do faturamento';

    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> alterarTipoRelatorio(TipoRelatorio tipo) async {
    if (_tipoRelatorio == tipo) return;

    _tipoRelatorio = tipo;
    notifyListeners();

    await carregarRelatorio();
  }

  Future<void> alterarPeriodo({
    required DateTime inicio,
    required DateTime fim,
  }) async {
    if (fim.isBefore(inicio)) {
      return;
    }

    // mantém o período selecionado, mas com o horário 00:00.
    final inicioPeriodo = DateTime(inicio.year, inicio.month, inicio.day);
    final fimPeriodo = DateTime(fim.year, fim.month, fim.day);

    this.inicio = inicioPeriodo;
    this.fim = fimPeriodo;

    await carregarRelatorio();
  }
}
