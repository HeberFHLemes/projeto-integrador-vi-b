import 'package:flutter/material.dart';

import '../../domain/cliente_repository.dart';
import '../../domain/cliente.dart';

class ClienteViewModel extends ChangeNotifier {

  final ClienteRepository _clienteRepository;

  ClienteViewModel(this._clienteRepository);

  /// Conjunto de clientes carregados
  List<Cliente> _clientes = [];

  /// Conjunto de clientes a ser apresentado
  List<Cliente> clientes = [];

  String termoBusca = '';

  bool mostrarAtivos = true;

  bool isLoading = false;
  String? errorMessage;

  Future<void> filtrarPorTermo(String termo) async {
    if (termo == termoBusca) return;

    termoBusca = termo;

    if (termo.isEmpty) {
      clientes = _clientes;

    } else {
      _aplicarFiltroPorTermo();
    }

    notifyListeners();
  }

  Future<void> carregarClientes() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      // busca dos clientes cadastrados, com filtro de ativos ou não.
      _clientes = mostrarAtivos
        ? await _clienteRepository.buscarAtivos()
        : await _clienteRepository.buscarInativos();

      clientes = _clientes;
      _aplicarFiltroPorTermo();

    } catch (e) {
      errorMessage = 'Não foi possível carregar os clientes.';
      clientes = [];

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

  void _aplicarFiltroPorTermo() {
    final busca = termoBusca.trim().toLowerCase();

    clientes = _clientes.where((c) {
      return c.nome.toLowerCase().contains(busca)
          || c.telefone.contains(busca);
    }).toList();
  }
}