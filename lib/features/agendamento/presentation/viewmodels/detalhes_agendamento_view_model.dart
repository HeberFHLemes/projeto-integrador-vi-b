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

  /// Altera o status de um agendamento. Se estiver como realizado,
  /// para não realizado. Se como agendado ou não realizado, para realizado.
  Future<void> alterarStatus() async {
    if (agendamento == null) {
      throw Exception('Agendamento não encontrado');
    }

    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final status = agendamento!.status;

      if (status == StatusAgendamento.realizado) {
        await _agendamentoRepository.desmarcarComoRealizado(agendamento!.id);

      } else {
        await _agendamentoRepository.marcarComoRealizado(agendamento!.id);

      }

      agendamento = await _agendamentoRepository.buscarPorId(agendamento!.id);

    } catch (e) {
      errorMessage = 'Não foi possível alterar o status do agendamento.';

    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Cancela (remove) um agendamento, se este ainda estiver como Agendado.
  Future<bool> cancelarAgendamento() async {
    if (agendamento == null) {
      throw Exception('Agendamento não encontrado');
    }

    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      if (agendamento!.status != StatusAgendamento.agendado) {
        throw Exception('Não é possível cancelar um agendamento passado');
      }

      await _agendamentoRepository.remover(agendamento!.id);

      return true;

    } catch (e) {
      errorMessage = 'Não foi possível cancelar o agendamento.';

      return false;

    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}