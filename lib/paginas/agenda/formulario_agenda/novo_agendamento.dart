class NovoAgendamento {
  const NovoAgendamento({
    required this.pacienteId,
    required this.clinicaId,
    required this.dataHora,
    required this.duracaoMinutos,
    required this.emitirNotaFiscal,
    this.sala = '',
  });

  final int pacienteId;
  final int? clinicaId;
  final DateTime dataHora;
  final int duracaoMinutos;
  final bool emitirNotaFiscal;
  final String sala;
}
