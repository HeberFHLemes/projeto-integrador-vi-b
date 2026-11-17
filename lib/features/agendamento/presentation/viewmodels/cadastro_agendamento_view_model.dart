import 'package:flutter/material.dart';

import '../../../cliente/domain/cliente.dart';
import '../../../cliente/domain/cliente_repository.dart';
import '../../../servicos/domain/servico_repository.dart';
import '../../../servicos/domain/servico.dart';
import '../../domain/agendamento_cadastro.dart';
import '../../domain/agendamento_repository.dart';

class CadastroAgendamentoViewModel extends ChangeNotifier {

  final AgendamentoRepository _agendamentoRepository;

  // Popular seletor de cliente
  final ClienteRepository _clienteRepository;

  // Popular seletor de serviço
  final ServicoRepository _servicoRepository;

  CadastroAgendamentoViewModel({
    required this._agendamentoRepository,
    required this._clienteRepository,
    required this._servicoRepository,
  });

  List<Cliente> clientes = [];
  List<Servico> servicos = [];

  int? clienteId; // id do cliente selecionado
  int? servicoId; // id do serviço selecionado

  DateTime? data;
  TimeOfDay? horario;

  String observacoes = '';

  bool isLoading = false;
  bool isSaving = false;
  String? errorMessage;

  Future<void> carregar() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      clientes = await _clienteRepository.buscarAtivos();
      servicos = await _servicoRepository.buscarAtivos();

    } catch (e) {
      errorMessage = 'Não foi possível carregar os dados.';

    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // opções de seleção no viewmodel para facilitar o cadastro
  void selecionarCliente(int? id) {
    clienteId = id;
    notifyListeners();
  }

  void selecionarServico(int? id) {
    servicoId = id;
    notifyListeners();
  }

  void selecionarData(DateTime? novaData) {
    data = novaData;
    notifyListeners();
  }

  void selecionarHorario(TimeOfDay? novoHorario) {
    horario = novoHorario;
    notifyListeners();
  }

  void atualizarObservacoes(String valor) {
    observacoes = valor;
  }

  // combinação dos valors do campo Data e Horário
  DateTime? get dataHora {
    if (data == null || horario == null) return null;

    return DateTime(
      data!.year,
      data!.month,
      data!.day,
      horario!.hour,
      horario!.minute,
    );
  }

  Future<bool> cadastrar() async {
    if (clienteId == null || servicoId == null || dataHora == null) {
      return false;
    }

    isSaving = true;
    errorMessage = null;
    notifyListeners();

    try {
      await _agendamentoRepository.cadastrar(
        AgendamentoCadastro(
          clienteId: clienteId!,
          servicoId: servicoId!,
          dataHora: dataHora!,
          observacoes: observacoes.trim().isEmpty
            ? null
            : observacoes.trim(),
        ),
      );

      return true;

    } catch (e) {
      errorMessage = 'Não foi possível cadastrar o agendamento.';
      return false;

    } finally {
      isSaving = false;
      notifyListeners();
    }
  }
}
