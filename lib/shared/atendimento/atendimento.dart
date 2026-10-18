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
    this.emitirNotaFiscal = false,
    this.notaFiscalEmitida = false,
  });

  final int id;
  final int pacienteId;
  final int? clinicaId;
  final String nomePaciente;
  final String nomeClinica;
  final DateTime dataHora;
  final String sala;
  final int duracaoMinutos;
  final String status;
  final bool emitirNotaFiscal;
  final bool notaFiscalEmitida;

  bool get notaFiscalPendente =>
      emitirNotaFiscal && status == 'Concluído' && !notaFiscalEmitida;

  String get situacaoNotaFiscal {
    if (!emitirNotaFiscal) return 'Não solicitada';
    if (notaFiscalEmitida) return 'Emitida';
    if (notaFiscalPendente) return 'Pendente de emissão';
    return 'Aguardando conclusão do atendimento';
  }

  Atendimento copyWith({String? status, bool? notaFiscalEmitida}) {
    return Atendimento(
      id: id,
      pacienteId: pacienteId,
      clinicaId: clinicaId,
      nomePaciente: nomePaciente,
      nomeClinica: nomeClinica,
      dataHora: dataHora,
      sala: sala,
      duracaoMinutos: duracaoMinutos,
      status: status ?? this.status,
      emitirNotaFiscal: emitirNotaFiscal,
      notaFiscalEmitida: notaFiscalEmitida ?? this.notaFiscalEmitida,
    );
  }

  String get horario {
    final hora = dataHora.hour.toString().padLeft(2, '0');
    final minuto = dataHora.minute.toString().padLeft(2, '0');
    return '$hora:$minuto';
  }

  String get local {
    if (clinicaId == null) {
      return 'Avulso';
    }

    if (sala.trim().isEmpty) {
      return nomeClinica;
    }

    return '$nomeClinica - Sala $sala';
  }
}
