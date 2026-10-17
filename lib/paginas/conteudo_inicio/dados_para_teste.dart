// Isso é provisório, porque eu já coloquei streams pra mostrar as coisas
// do inicio. Desse jeito eu separei as informações específicas da apresentação
// delas com os widgets. O banco de dados que vai substituir isso. - Gustavo

import 'package:pex/shared/atendimento/atendimento.dart';
import 'package:pex/shared/atendimento/dados_em_memoria.dart';

// IDs fictícios. Quando conectar o banco, usar os IDs dos registros.
// A lista compartilhada fica em shared/atendimento/dados_em_memoria.dart.

// Dados para os contadores
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

// Dados para o card de próximo atendimento
Stream<Atendimento?> criarStreamProximoAtendimento() {
  // Mostra o primeiro agendado do dia, inclusive se estiver atrasado.
  // atendimentosHoje() já entrega a lista em ordem de horário.
  return observarDadosEmMemoria<Atendimento?>(() {
    for (final atendimento in atendimentosHoje()) {
      if (atendimento.status == 'Agendado') {
        return atendimento;
      }
    }

    return null;
  });
}

// dados para a lista da agenda de hoje
List<Atendimento> atendimentosHoje() {
  return atendimentosDoDia(DateTime.now());
}

// Mantém a lista de hoje atualizada enquanto o início estiver aberto.
Stream<List<Atendimento>> criarStreamAgendaHoje() {
  return observarDadosEmMemoria(atendimentosHoje);
}
