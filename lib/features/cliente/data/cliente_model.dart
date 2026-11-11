import '../domain/cliente.dart';

/// Modelo de dados de Cliente
class ClienteModel extends Cliente {
  const ClienteModel({
    required super.id,
    required super.nome,
    required super.telefone,
    required super.criadoEm,
    required super.ativo,
  });

  factory ClienteModel.fromMap(Map<String, Object?> map) {
    return ClienteModel(
      id: map['id'] as int,
      nome: map['nome'] as String,
      telefone: map['telefone'] as String,
      criadoEm: DateTime.parse(map['criado_em'] as String),
      ativo: (map['ativo'] as int) == 1,
    );
  }

  static Map<String, Object?> toMap(Cliente cliente) {
    return {
      'id': cliente.id,
      'nome': cliente.nome,
      'telefone': cliente.telefone,
      'criado_em': cliente.criadoEm.toUtc().toIso8601String(),
      'ativo': cliente.ativo ? 1 : 0,
    };
  }
}
