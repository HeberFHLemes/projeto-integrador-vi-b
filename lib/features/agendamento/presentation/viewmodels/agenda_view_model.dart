import 'package:flutter/material.dart';

import '../../domain/agendamento.dart';
import '../../domain/agendamento_repository.dart';

class AgendaViewModel extends ChangeNotifier {

  final AgendamentoRepository _agendamentoRepository;

  AgendaViewModel(this._agendamentoRepository);

  /// Conjunto de agendamentos carregados
  List<Agendamento> _agendamentos = [];

  /// Conjunto de agendamentos a serrem apresentados
  List<Agendamento> agendamentos = [];

  String termoBusca = '';

  bool mostrarAtivos = true;

  bool isLoading = false;
  String? errorMessage;

  DateTime _dataSelecionada = DateUtils.dateOnly(
    DateTime.now(),
  );

  DateTime get dataSelecionada => _dataSelecionada;

  Future<void> selecionarData(DateTime data) async {
    _dataSelecionada = DateUtils.dateOnly(data);

    notifyListeners();

    await carregarAgendamentos();
  }

  Future<void> carregarAgendamentos() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      // busca dos agendamentos cadastrados de um dia
      _agendamentos = await _agendamentoRepository.buscarPorDia(
        _dataSelecionada
      );

      agendamentos = _agendamentos;

    } catch (e) {
      errorMessage = 'Não foi possível carregar os agendamentos.';
      agendamentos = [];
      rethrow;

    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
