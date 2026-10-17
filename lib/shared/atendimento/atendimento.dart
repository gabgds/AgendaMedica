// Organiza os dados de um atendimento para uso nos cards e no modal de detalhes.
// Atualmente recebe dados de teste que vem de dados_agenda_teste.dart, depois receberá dados consultados no banco.

class Atendimento {
  const Atendimento({
    required this.id,
    required this.pacienteId,
    required this.clinicaId,
    required this.nomePaciente,
    required this.nomeClinica,
    required this.dataHora,
    required this.sala,
    required this.duracaoMinutos,
    required this.status,
  });

  final int id;
  final int pacienteId;
  final int clinicaId;
  final String nomePaciente;
  final String nomeClinica;
  final DateTime dataHora;
  final String sala;
  final int duracaoMinutos;
  final String status;

  String get horario {
    final hora = dataHora.hour.toString().padLeft(2, '0');
    final minuto = dataHora.minute.toString().padLeft(2, '0');
    return '$hora:$minuto';
  }

  String get local {
    if (sala.trim().isEmpty) {
      return nomeClinica;
    }
    return '$nomeClinica - Sala $sala';
  }
}
