import 'package:pex/shared/atendimento/atendimento.dart';
import 'package:pex/shared/atendimento/dados_em_memoria.dart';

Stream<List<Atendimento>> criarStreamAgenda(DateTime data) {
  return observarDadosEmMemoria(() => atendimentosDoDia(data));
}
