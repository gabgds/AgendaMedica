// Dados da clínica exibidos na listagem e no cadastro.
class Clinica {
  const Clinica({
    required this.id,
    required this.nome,
    required this.endereco,
    required this.telefone,
  });

  final int id;
  final String nome;
  final String endereco;
  final String telefone;
}
