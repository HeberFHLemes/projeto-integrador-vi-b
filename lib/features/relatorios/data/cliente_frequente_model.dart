import '../domain/cliente_frequente.dart';

class ClienteFrequenteModel extends ClienteFrequente {

  const ClienteFrequenteModel({
    required super.id,
    required super.nome,
    required super.quantidadeAtendimentos,
    required super.ultimaVisita,
  });

  factory ClienteFrequenteModel.fromMap(Map<String, Object?> map) {
    return ClienteFrequenteModel(
      id: map['id'] as int,
      nome: map['nome'] as String,
      quantidadeAtendimentos: map['quantidade_atendimentos'] as int,
      ultimaVisita: DateTime.parse(map['ultima_visita'] as String),
    );
  }
}