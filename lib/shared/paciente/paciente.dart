// Modelo com os dados do paciente exibidos pelas telas.
class Paciente {
  const Paciente({
    required this.id,
    required this.nome,
    required this.telefone,
  });

  final int id;
  final String nome;
  final String telefone;
}
