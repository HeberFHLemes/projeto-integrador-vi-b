import 'package:flutter/material.dart';

import '../../domain/cliente.dart';
import '../../domain/cliente_repository.dart';

class FichaClienteViewModel extends ChangeNotifier {

  final ClienteRepository _clienteRepository;

  FichaClienteViewModel(this._clienteRepository);

  Cliente? cliente;

  bool isLoading = false;
  String? errorMessage;

  Future<void> buscarAgendamentosCliente() async {
    if (cliente == null) return;

    // TODO: buscar agendamentos relacionados ao cliente.
  }

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

    } catch (e) {
      errorMessage = 'Não foi possível carregar os dados do cliente.';

    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}