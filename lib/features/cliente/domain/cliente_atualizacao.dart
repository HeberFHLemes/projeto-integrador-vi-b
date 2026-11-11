/// Dados necessários para atualizar um cliente.
class ClienteAtualizacao {
  const ClienteAtualizacao({
    required this.id,
    required this.nome,
    required this.telefone,
  });

  final int id;
  final String nome;
  final String telefone;
}