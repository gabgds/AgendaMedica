// PROVISÓRIO: pacientes e clínicas do seletor vêm de listas em memória.
// Substituir estas leituras por consultas ao banco com Drift.

import '../../clinicas/dados_clinicas_em_memoria.dart';
import '../../clinicas/dados_clinicas_teste.dart';
import '../../pacientes/dados_pacientes_em_memoria.dart';
import '../../pacientes/dados_pacientes_teste.dart';

// Inclui os cadastros atuais e preserva os IDs do histórico das consultas.
Map<int, String> get pacientesAgendamentoTeste => {
  for (final paciente in pacientesEmMemoria(pacientesTeste))
    paciente.id: paciente.nome,
};

Map<int, String> get clinicasAgendamentoTeste => {
  for (final clinica in clinicasEmMemoria(clinicasTeste))
    clinica.id: clinica.nome,
};
