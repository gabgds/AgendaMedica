import 'package:pex/shared/atendimento/atendimento.dart';
import 'package:pex/shared/atendimento/dados_em_memoria.dart';

// IDs fictícios apenas para teste. No banco, usaremos os IDs dos registros.
// A lista compartilhada fica em shared/atendimento/dados_em_memoria.dart.

// Depois, substituir por uma consulta ao banco que filtre pela data.
Stream<List<Atendimento>> criarStreamAgenda(DateTime data) {
  return observarDadosEmMemoria(() => atendimentosDoDia(data));
}
