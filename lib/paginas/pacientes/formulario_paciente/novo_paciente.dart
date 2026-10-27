import '../paciente.dart';

class NovoPaciente {
  const NovoPaciente({
    required this.nome,
    required this.dataNascimento,
    required this.cpf,
    required this.endereco,
    required this.email,
    required this.telefone,
  });

  final String nome;
  final DateTime dataNascimento;
  final String cpf;
  final String endereco;
  final String email;
  final String telefone;

  Paciente paraPaciente({required int id}) {
    return Paciente(
      id: id,
      nome: nome,
      telefone: telefone,
      dataNascimento: dataNascimento,
      cpf: cpf,
      endereco: endereco,
      email: email,
    );
  }
}
