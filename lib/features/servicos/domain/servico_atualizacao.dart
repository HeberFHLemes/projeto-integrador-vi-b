/// Dados necessários para atualizar um serviço.
class ServicoAtualizacao {
  const ServicoAtualizacao({
    required this.id,
    required this.nome,
    required this.preco,
  });

  final int id;
  final String nome;
  final int preco;
}