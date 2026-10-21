import 'package:pex/shared/atendimento/atendimento.dart';
import 'package:pex/shared/atendimento/dados_em_memoria.dart';

Stream<Map<String, int>> criarStreamContadores() {
  return observarDadosEmMemoria(() {
    final atendimentos = atendimentosHoje();
    final concluidos = atendimentos.where((atendimento) {
      return atendimento.status == 'Concluído';
    }).length;

    return {
      'hoje': atendimentos.length,
      'concluidos': concluidos,
    };
  });
}

Stream<Atendimento?> criarStreamProximoAtendimento() {
  return observarDadosEmMemoria<Atendimento?>(() {
    for (final atendimento in atendimentosHoje()) {
      if (atendimento.status == 'Agendado') {
        return atendimento;
      }
    }

    return null;
  });
}

List<Atendimento> atendimentosHoje() {
  return atendimentosDoDia(DateTime.now());
}

Stream<List<Atendimento>> criarStreamAgendaHoje() {
  return observarDadosEmMemoria(atendimentosHoje);
}
