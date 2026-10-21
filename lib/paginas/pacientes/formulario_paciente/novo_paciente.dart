import '../paciente.dart';

class NovoPaciente {
  const NovoPaciente({
    required this.nome,
    required this.dataNascimento,
    required this.cpf,
    required this.endereco,
    required this.email,
    required this.telefone,
    this.clinicaId,
  });

  final String nome;
  final DateTime dataNascimento;
  final String cpf;
  final String endereco;
  final String email;
  final String telefone;
  final int? clinicaId;

  Paciente paraPaciente({required int id, String nomeClinica = ''}) {
    return Paciente(
      id: id,
      nome: nome,
      telefone: telefone,
      dataNascimento: dataNascimento,
      cpf: cpf,
      endereco: endereco,
      email: email,
      clinicaId: clinicaId,
      nomeClinica: clinicaId == null ? '' : nomeClinica,
    );
  }
}
