import 'package:pex/database/status_agendamento.dart';
import 'package:pex/repositorios/agendamentos_repositorio.dart';
import 'package:pex/shared/atendimento/atendimento.dart';

Stream<Map<String, int>> criarStreamContadores() {
  return criarStreamAgendaHoje().map((atendimentos) {
    final concluidos = atendimentos.where((atendimento) {
      return atendimento.status == StatusAgendamento.concluido;
    }).length;

    return {
      'hoje': atendimentos.length,
      'concluidos': concluidos,
    };
  });
}

Stream<Atendimento?> criarStreamProximoAtendimento() {
  return criarStreamAgendaHoje().map((atendimentos) {
    for (final atendimento in atendimentos) {
      if (atendimento.status == StatusAgendamento.agendado) {
        return atendimento;
      }
    }

    return null;
  });
}

Stream<List<Atendimento>> criarStreamAgendaHoje() {
  return observarAtendimentosDoDia(DateTime.now());
}
