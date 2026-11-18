import 'package:flutter/material.dart';

import '../../domain/agendamento.dart';

extension StatusAgendamentoExtension on StatusAgendamento {
  String get label {
    return switch (this) {
      StatusAgendamento.agendado => 'Agendado',
      StatusAgendamento.naoRealizado => 'Não realizado',
      StatusAgendamento.realizado => 'Realizado',
    };
  }

  Color color(ColorScheme colorScheme) {
    return switch (this) {
      StatusAgendamento.naoRealizado => colorScheme.error,
      _ => colorScheme.primary,
    };
  }
}