import 'package:flutter/material.dart';

import '../../../cliente/domain/cliente.dart';
import '../../../cliente/domain/cliente_repository.dart';
import '../../../servicos/domain/servico.dart';
import '../../../servicos/domain/servico_repository.dart';
import '../../domain/agendamento_atualizacao.dart';
import '../../domain/agendamento_repository.dart';
import '../../domain/agendamento.dart';

class AtualizacaoAgendamentoViewModel extends ChangeNotifier {

  AtualizacaoAgendamentoViewModel({
    required this._agendamentoRepository,
    required this._clienteRepository,
    required this._servicoRepository,
  });

  final AgendamentoRepository _agendamentoRepository;
  final ClienteRepository _clienteRepository;
  final ServicoRepository _servicoRepository;

  List<Cliente> clientes = [];
  List<Servico> servicos = [];

  int? agendamentoId;

  int? clienteId;
  int? servicoId;

  DateTime? data;
  TimeOfDay? horario;

  String observacoes = '';

  bool isLoading = false;
  bool isSaving = false;
  String? errorMessage;

  Future<void> buscarAgendamento(int id) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final resultados = await Future.wait([
        _agendamentoRepository.buscarPorId(id),
        _clienteRepository.buscarAtivos(),
        _servicoRepository.buscarAtivos(),
      ]);

      final agendamento = resultados[0] as Agendamento;

      clientes = resultados[1] as List<Cliente>;
      servicos = resultados[2] as List<Servico>;

      agendamentoId = id;

      clienteId = agendamento.cliente.id;
      servicoId = agendamento.servico.id;

      final dataLocal = agendamento.dataHora.toLocal();

      data = dataLocal;

      horario = TimeOfDay(
        hour: dataLocal.hour,
        minute: dataLocal.minute,
      );

      observacoes = agendamento.observacoes ?? '';

    } catch (e) {
      errorMessage = 'Não foi possível carregar os dados do agendamento';

    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

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

  Future<bool> atualizarAgendamento() async {
    if (agendamentoId == null ||
      clienteId == null ||
      servicoId == null ||
      dataHora == null
    ) {
      return false;
    }

    isSaving = true;
    errorMessage = null;
    notifyListeners();

    try {
      await _agendamentoRepository.atualizar(
        AgendamentoAtualizacao(
          id: agendamentoId!,
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
      errorMessage = 'Não foi possível atualizar o agendamento';
      return false;

    } finally {
      isSaving = false;
      notifyListeners();
    }
  }
}