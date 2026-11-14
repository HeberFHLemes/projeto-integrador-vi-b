import 'package:flutter/material.dart';

import '../../domain/servico_repository.dart';
import '../../domain/servico.dart';

class ServicosViewModel extends ChangeNotifier {

  final ServicoRepository _servicoRepository;

  ServicosViewModel(this._servicoRepository);

  /// Conjunto de serviços a serem apresentados
  List<Servico> servicos = [];

  /// Conjunto de serviços carregados
  List<Servico> _servicos = [];

  String termoBusca = '';

  bool mostrarAtivos = true;

  bool isLoading = false;
  String? errorMessage;

  Future<void> carregarServicos() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      // busca dos serviços cadastrados
      _servicos = mostrarAtivos
        ? await _servicoRepository.buscarAtivos()
        : await _servicoRepository.buscarInativos();

      _aplicarFiltroPorNome();
    } catch (e) {
      errorMessage = 'Não foi possível carregar os serviços.';
      servicos = [];

    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> alterarFiltro(bool ativo) async {
    if (mostrarAtivos == ativo) return;

    mostrarAtivos = ativo;
    await carregarServicos();
  }

  void filtrarPorNome(String valor) {
    if (termoBusca == valor) return;

    termoBusca = valor;

    if (valor.isEmpty) {
      servicos = _servicos;
    } else {
      _aplicarFiltroPorNome();
    }

    notifyListeners();
  }

  // Filtro básico por nome, sem novas buscas no banco
  void _aplicarFiltroPorNome() {
    final busca = termoBusca.trim().toLowerCase();

    servicos = _servicos.where((servico) {
      return servico.nome.toLowerCase().contains(busca);
    }).toList();
  }
}