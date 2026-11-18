import 'package:flutter/material.dart';

import '../../../agendamento/domain/agendamento.dart';
import '../../../agendamento/domain/agendamento_repository.dart';
import '../../domain/cliente.dart';
import '../../domain/cliente_repository.dart';

class FichaClienteViewModel extends ChangeNotifier {

  final ClienteRepository _clienteRepository;

  // Para os agendamentos do cliente
  final AgendamentoRepository _agendamentoRepository;

  FichaClienteViewModel({
    required this._clienteRepository,
    required this._agendamentoRepository,
  });

  Cliente? cliente;
  List<Agendamento> agendamentos = [];

  bool isLoading = false;
  String? errorMessage;

  Future<void> buscarCliente(int id) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      // busca do cliente com o id
      cliente = await _clienteRepository.buscarPorId(id);

      if (cliente == null) {
        throw Exception('Cliente não encontrado (id=$id)');
      }

      agendamentos = await _agendamentoRepository.buscarPorCliente(id);

    } catch (e) {
      errorMessage = 'Não foi possível carregar os dados do cliente.';

    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
