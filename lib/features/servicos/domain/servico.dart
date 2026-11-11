/// Entidade de domínio Serviço
class Servico {
  const Servico({
    required this.id,
    required this.nome,
    required this.preco,
    required this.ativo,
  });

  final int id;
  final String nome;
  final int preco; // em centavos
  final bool ativo;
}