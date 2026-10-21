class NovoAgendamento {
  const NovoAgendamento({
    required this.pacienteId,
    required this.clinicaId,
    required this.dataHora,
    required this.duracaoMinutos,
    required this.emitirNotaFiscal,
  });

  final int pacienteId;
  final int? clinicaId;
  final DateTime dataHora;
  final int duracaoMinutos;
  final bool emitirNotaFiscal;
}
