import 'package:flutter/material.dart';

import '../../domain/servico.dart';
import '../../domain/servico_atualizacao.dart';
import '../../domain/servico_repository.dart';

class AtualizacaoServicoViewModel extends ChangeNotifier {

  final ServicoRepository _servicoRepository;

  AtualizacaoServicoViewModel(this._servicoRepository);

  bool isLoading = false;
  String? errorMessage;

  late final Servico? servico;

  Future<void> buscarServico(int id) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      // busca pelo serviço
      servico = await _servicoRepository.buscarPorId(id);

    } catch (e) {
      errorMessage = 'Não foi possível carregar os dados do serviço.';

    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> atualizarServico({
    required String nome,
    required int preco,
  }) async {
    final atual = servico;

    if (atual == null) return false;

    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final atualizacao = ServicoAtualizacao(
        id: atual.id,
        nome: nome,
        preco: preco,
      );

      // atualização dos campos nome e preço do Serviço
      await _servicoRepository.atualizar(atualizacao);

      return true;

    } catch (e) {
      errorMessage = 'Não foi possível atualizar os dados do serviço.';
      return false;

    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> alterarStatusServico() async {
    final atual = servico;

    if (atual == null) return false;

    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      if (atual.ativo) {
        await _servicoRepository.desativar(atual.id);

      } else {
        await _servicoRepository.ativar(atual.id);
      }

      return true;

    } catch (e) {
      errorMessage = 'Não foi possível alterar o status do serviço.';
      return false;

    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}