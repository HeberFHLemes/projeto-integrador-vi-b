import 'package:flutter/material.dart';

import '../../../../core/utils/phone_number_utils.dart';
import '../../domain/cliente.dart';
import '../../domain/cliente_atualizacao.dart';
import '../../domain/cliente_repository.dart';

class AtualizacaoClienteViewModel extends ChangeNotifier {

  final ClienteRepository _clienteRepository;

  AtualizacaoClienteViewModel(this._clienteRepository);

  bool isLoading = false;
  String? errorMessage;

  late final Cliente? cliente;

  Future<void> buscarCliente(int id) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      // busca pelo cliente
      cliente = await _clienteRepository.buscarPorId(id);

    } catch (e) {
      errorMessage = 'Não foi possível carregar os dados do cliente.';

    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> atualizarCliente({
    required String nome,
    required String telefone,
  }) async {
    final atual = cliente;

    if (atual == null) return false;

    isLoading = true;
    errorMessage = null;
    notifyListeners();

    // atualização dos campos nome e telefone do cliente
    try {
      final atualizacao = ClienteAtualizacao(
        id: atual.id,
        nome: nome.trim(),
        telefone: PhoneNumberUtils.onlyDigits(telefone),
      );

      await _clienteRepository.atualizar(atualizacao);

      return true;

    } catch (e) {
      errorMessage = 'Não foi possível atualizar os dados do cliente.';
      return false;

    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> alterarStatusCliente() async {
    final atual = cliente;

    if (atual == null) return false;

    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      if (atual.ativo) {
        await _clienteRepository.desativar(atual.id);

      } else {
        await _clienteRepository.ativar(atual.id);
      }

      return true;

    } catch (e) {
      errorMessage = 'Não foi possível alterar o status do cliente.';
      return false;

    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
