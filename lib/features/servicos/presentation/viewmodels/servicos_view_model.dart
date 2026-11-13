import 'package:flutter/material.dart';

import '../../domain/servico_repository.dart';
import '../../domain/servico.dart';

class ServicosViewModel extends ChangeNotifier {

  final ServicoRepository _servicoRepository;

  ServicosViewModel(this._servicoRepository);

  /// Conjunto de servicos encontrados
  List<Servico> servicos = [];

  bool mostrarAtivos = true;

  bool isLoading = false;
  String? errorMessage;

  Future<void> carregarServicos() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      // busca dos serviços cadastrados
      servicos = mostrarAtivos
          ? await _servicoRepository.buscarAtivos()
          : await _servicoRepository.buscarInativos();

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
}