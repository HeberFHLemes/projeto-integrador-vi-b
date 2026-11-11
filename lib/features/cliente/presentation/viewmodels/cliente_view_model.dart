import 'package:flutter/material.dart';

import '../../domain/cliente_repository.dart';
import '../../domain/cliente.dart';

class ClienteViewModel extends ChangeNotifier {

  final ClienteRepository _clienteRepository;

  ClienteViewModel(this._clienteRepository);

  List<Cliente> clientes = [];

  bool mostrarAtivos = true;
  bool isLoading = false;
  String? errorMessage;

  Future<void> carregarClientes() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      // busca dos clientes cadastrados, com filtro de ativos ou não.
      clientes = mostrarAtivos
        ? await _clienteRepository.buscarAtivos()
        : await _clienteRepository.buscarInativos();

    } catch (e) {
      errorMessage = 'Não foi possível carregar os clientes.';

    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> alterarFiltro(bool ativo) async {
    if (mostrarAtivos == ativo) return;

    mostrarAtivos = ativo;
    await carregarClientes();
  }
}