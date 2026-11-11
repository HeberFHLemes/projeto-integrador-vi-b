/// Entidade de domínio Cliente como será usada na aplicação.
class Cliente {
  const Cliente({
    required this.id,
    required this.nome,
    required this.telefone,
    required this.criadoEm,
    required this.ativo,
  });

  final int id;
  final String nome;
  final String telefone;
  final DateTime criadoEm;
  final bool ativo;
}