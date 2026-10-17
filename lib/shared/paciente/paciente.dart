// Modelo com os dados do paciente exibidos pelas telas.
class Paciente {
  const Paciente({
    required this.id,
    required this.nome,
    required this.telefone,
    this.dataNascimento,
    this.cpf = '',
    this.endereco = '',
    this.email = '',
    this.emitirNotaFiscal = false,
    this.clinicaId,
  });

  final int id;
  final String nome;
  final String telefone;
  final DateTime? dataNascimento;
  final String cpf;
  final String endereco;
  final String email;
  final bool emitirNotaFiscal;
  // null indica um paciente avulso, sem vínculo com clínica.
  final int? clinicaId;
}
