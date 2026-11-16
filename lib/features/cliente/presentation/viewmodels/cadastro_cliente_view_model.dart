import 'package:flutter/material.dart';

import '../../../../core/utils/phone_number_utils.dart';
import '../../domain/cliente_cadastro.dart';
import '../../domain/cliente_repository.dart';

class CadastroClienteViewModel extends ChangeNotifier {

  final ClienteRepository _clienteRepository;

  CadastroClienteViewModel(this._clienteRepository);

  bool isLoading = false;
  String? errorMessage;

  Future<void> cadastrarCliente({
    required String nome,
    required String telefone
  }) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final cliente = ClienteCadastro(
        nome: nome.trim(),
        telefone: PhoneNumberUtils.onlyDigits(telefone),
      );

      // cadastro
      await _clienteRepository.cadastrar(cliente);

    } catch (e) {
      errorMessage = 'Não foi possível cadastrar o cliente.';

    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}