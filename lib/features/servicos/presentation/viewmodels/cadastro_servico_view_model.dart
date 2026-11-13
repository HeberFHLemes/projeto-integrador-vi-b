import 'package:flutter/material.dart';

import '../../domain/servico_cadastro.dart';
import '../../domain/servico_repository.dart';

class CadastroServicoViewModel extends ChangeNotifier {

  final ServicoRepository _servicoRepository;

  CadastroServicoViewModel(this._servicoRepository);

  bool isLoading = false;
  String? errorMessage;

  Future<void> cadastrarServico({
    required String nome,
    required int preco
  }) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      ServicoCadastro servico = ServicoCadastro(
        nome: nome,
        preco: preco,
      );

      // cadastro do serviço
      await _servicoRepository.cadastrar(servico);

    } catch (e) {
      errorMessage = 'Não foi possível cadastrar o serviço.';

    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}