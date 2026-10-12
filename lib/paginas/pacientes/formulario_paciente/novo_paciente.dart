import 'package:pex/shared/paciente/paciente.dart';

// Dados preenchidos no formulário. O ID é definido ao salvar o paciente.
class NovoPaciente {
  const NovoPaciente({
    required this.nome,
    required this.dataNascimento,
    required this.cpf,
    required this.endereco,
    required this.email,
    required this.telefone,
    required this.emitirNotaFiscal,
    required this.clinicaId,
  });

  final String nome;
  final DateTime dataNascimento;
  final String cpf;
  final String endereco;
  final String email;
  final String telefone;
  final bool emitirNotaFiscal;
  // null indica a opção Avulso, como no formulário de agendamento.
  final int? clinicaId;

  // A mesma conversão é usada no cadastro e na edição, preservando o ID.
  Paciente paraPaciente({required int id}) {
    return Paciente(
      id: id,
      nome: nome,
      telefone: telefone,
      dataNascimento: dataNascimento,
      cpf: cpf,
      endereco: endereco,
      email: email,
      emitirNotaFiscal: emitirNotaFiscal,
      clinicaId: clinicaId,
    );
  }
}
