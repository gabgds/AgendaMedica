// PROVISÓRIO: os cadastros de pacientes ficam apenas na memória.
// Os dados são perdidos ao encerrar o aplicativo.
// Substituir por consultas e gravações no banco de dados com Drift.

import 'paciente.dart';

final _pacientesCadastrados = <Paciente>[];
final _pacientesEditados = <int, Paciente>{};
final _pacientesRemovidos = <int>{};

List<Paciente> pacientesEmMemoria(List<Paciente> pacientesIniciais) {
  final pacientesPorId = <int, Paciente>{
    for (final paciente in pacientesIniciais) paciente.id: paciente,
    for (final paciente in _pacientesCadastrados) paciente.id: paciente,
  };

  return [
    for (final paciente in pacientesPorId.values)
      if (!_pacientesRemovidos.contains(paciente.id))
        _pacientesEditados[paciente.id] ?? paciente,
  ];
}

void adicionarPacienteEmMemoria(Paciente paciente) {
  _pacientesRemovidos.remove(paciente.id);
  _pacientesEditados.remove(paciente.id);
  _pacientesCadastrados.add(paciente);
}

void atualizarPacienteEmMemoria(Paciente paciente) {
  _pacientesEditados[paciente.id] = paciente;
}

void removerPacienteEmMemoria(int pacienteId) {
  // Também permite remover dados de teste sem alterar a lista constante.
  _pacientesRemovidos.add(pacienteId);
  _pacientesEditados.remove(pacienteId);
}

int proximoIdPacienteEmMemoria(List<Paciente> pacientesIniciais) {
  final ids = <int>{
    for (final paciente in pacientesIniciais) paciente.id,
    for (final paciente in _pacientesCadastrados) paciente.id,
    ..._pacientesEditados.keys,
    ..._pacientesRemovidos,
  };
  var maiorId = 0;
  for (final id in ids) {
    if (id > maiorId) maiorId = id;
  }
  // Não reutiliza o ID de um paciente removido durante esta execução.
  return maiorId + 1;
}
