// PROVISÓRIO: os cadastros de clínicas ficam apenas na memória.
// Os dados são perdidos ao encerrar o aplicativo.
// Substituir por consultas e gravações no banco de dados com Drift.

import 'clinica.dart';

final _clinicasCadastradas = <Clinica>[];
final _clinicasEditadas = <int, Clinica>{};
final _clinicasRemovidas = <int>{};

List<Clinica> clinicasEmMemoria(List<Clinica> clinicasIniciais) {
  final clinicasPorId = <int, Clinica>{
    for (final clinica in clinicasIniciais) clinica.id: clinica,
    for (final clinica in _clinicasCadastradas) clinica.id: clinica,
  };
  return [
    for (final clinica in clinicasPorId.values)
      if (!_clinicasRemovidas.contains(clinica.id))
        _clinicasEditadas[clinica.id] ?? clinica,
  ];
}

void adicionarClinicaEmMemoria(Clinica clinica) {
  _clinicasEditadas.remove(clinica.id);
  _clinicasRemovidas.remove(clinica.id);
  _clinicasCadastradas.add(clinica);
}

void atualizarClinicaEmMemoria(Clinica clinica) {
  _clinicasEditadas[clinica.id] = clinica;
}

void removerClinicaEmMemoria(int clinicaId) {
  // Remove também exemplos da lista inicial, sem modificar a lista constante.
  _clinicasRemovidas.add(clinicaId);
  _clinicasEditadas.remove(clinicaId);
}

int proximoIdClinicaEmMemoria(List<Clinica> clinicasIniciais) {
  final ids = <int>{
    for (final clinica in clinicasIniciais) clinica.id,
    for (final clinica in _clinicasCadastradas) clinica.id,
    ..._clinicasEditadas.keys,
    ..._clinicasRemovidas,
  };
  var maiorId = 0;
  for (final id in ids) {
    if (id > maiorId) maiorId = id;
  }
  // Mantém os IDs únicos mesmo depois de remover a clínica com o maior ID.
  return maiorId + 1;
}
