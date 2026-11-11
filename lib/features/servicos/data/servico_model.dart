import '../domain/servico.dart';

class ServicoModel extends Servico {
  ServicoModel({
    required super.id,
    required super.nome,
    required super.preco,
    required super.ativo
  });

  factory ServicoModel.fromMap(Map<String, Object?> map) {
    return ServicoModel(
      id: map['id'] as int,
      nome: map['nome'] as String,
      preco: map['preco'] as int,
      ativo: (map['ativo'] as int) == 1,
    );
  }

  static Map<String, Object?> toMap(Servico servico) {
    return {
      'id': servico.id,
      'nome': servico.nome,
      'preco': servico.preco,
      'ativo': servico.ativo ? 1 : 0,
    };
  }
}