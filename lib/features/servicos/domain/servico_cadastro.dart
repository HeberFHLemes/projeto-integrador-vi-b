/// Dados necessários de um serviço na hora de cadastrar
class ServicoCadastro {
  const ServicoCadastro({
    required this.nome,
    required this.preco,
  });

  final String nome;
  final int preco;
}