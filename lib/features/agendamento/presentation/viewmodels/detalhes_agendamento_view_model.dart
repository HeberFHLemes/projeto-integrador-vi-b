import 'package:flutter/material.dart';

import '../../../agendamento/domain/agendamento.dart';
import '../../../agendamento/domain/agendamento_repository.dart';

class DetalhesAgendamentoViewModel extends ChangeNotifier {

  final AgendamentoRepository _agendamentoRepository;

  DetalhesAgendamentoViewModel(this._agendamentoRepository);

  Agendamento? agendamento;

  bool isLoading = false;
  String? errorMessage;

  Future<void> buscarAgendamento(int id) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      // busca do agendamento com o id
      agendamento = await _agendamentoRepository.buscarPorId(id);

      if (agendamento == null) {
        throw Exception('Agendamento não encontrado (id=$id)');
      }

    } catch (e) {
      errorMessage = 'Não foi possível carregar os dados do agendamento.';

    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}