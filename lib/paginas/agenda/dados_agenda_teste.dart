// PROVISÓRIO: a Agenda consulta atendimentos em memória.
// Substituir estas consultas por consultas ao banco com Drift.
// Filtrar pela data e manter o stream consumido pela tela.

import 'package:pex/shared/atendimento/atendimento.dart';
import 'package:pex/shared/atendimento/dados_em_memoria.dart';

// IDs fictícios apenas para teste. No banco, usaremos os IDs dos registros.
// A lista compartilhada fica em shared/atendimento/dados_em_memoria.dart.

Stream<List<Atendimento>> criarStreamAgenda(DateTime data) {
  return observarDadosEmMemoria(() => atendimentosDoDia(data));
}
