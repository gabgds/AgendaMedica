// Guarda os dados preenchidos no formulário para serem salvos no banco.
// O ID do agendamento será definido quando o registro for inserido.
class NovoAgendamento {
  const NovoAgendamento({
    required this.pacienteId,
    required this.clinicaId,
    required this.dataHora,
    required this.duracaoMinutos,
  });

  final int pacienteId;
  // null indica uma consulta avulsa, sem vínculo com clínica.
  final int? clinicaId;
  final DateTime dataHora;
  final int duracaoMinutos;
}
