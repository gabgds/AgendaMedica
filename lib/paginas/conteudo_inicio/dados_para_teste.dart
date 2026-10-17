// Isso é provisório, porque eu já coloquei streams pra mostrar as coisas
// do inicio. Desse jeito eu separei as informações específicas da apresentação
// delas com os widgets. O banco de dados que vai substituir isso. - Gustavo

import '../../shared/atendimento/atendimento.dart';

// IDs fictícios. Quando conectar o banco, usar os IDs dos registros.
final _hoje = DateTime.now();
final _atendimentos = [
  Atendimento(
    id: 1,
    pacienteId: 1,
    clinicaId: 1,
    nomePaciente: 'Ana Carolina',
    nomeClinica: 'Clínica Saúde',
    dataHora: DateTime(_hoje.year, _hoje.month, _hoje.day, 10),
    sala: '3',
    duracaoMinutos: 60,
    status: 'Concluído',
  ),
  Atendimento(
    id: 2,
    pacienteId: 2,
    clinicaId: 1,
    nomePaciente: 'Maria Silva',
    nomeClinica: 'Clínica Saúde',
    dataHora: DateTime(_hoje.year, _hoje.month, _hoje.day, 14),
    sala: '3',
    duracaoMinutos: 60,
    status: 'Agendado',
  ),
  Atendimento(
    id: 3,
    pacienteId: 3,
    clinicaId: 2,
    nomePaciente: 'João Pedro',
    nomeClinica: 'Clínica Multicare',
    dataHora: DateTime(_hoje.year, _hoje.month, _hoje.day, 16),
    sala: '2',
    duracaoMinutos: 60,
    status: 'Agendado',
  ),
];

// Dados para os contadores
Stream<Map<String, int>> criarStreamContadores() {
  final atendimentos = atendimentosHoje();
  final concluidos = atendimentos.where((atendimento) {
    return atendimento.status == 'Concluído';
  }).length;

  return Stream.value({
    'hoje': atendimentos.length,
    'concluidos': concluidos,
  });
}

// Dados para o card de próximo atendimento
Stream<Atendimento?> criarStreamProximoAtendimento() {
  // Mostra o primeiro agendado do dia, inclusive se estiver atrasado.
  // atendimentosHoje() já entrega a lista em ordem de horário.
  for (final atendimento in atendimentosHoje()) {
    if (atendimento.status == 'Agendado') {
      return Stream<Atendimento?>.value(atendimento);
    }
  }

  return Stream<Atendimento?>.value(null);
}

// dados para a lista da agenda de hoje
List<Atendimento> atendimentosHoje() {
  final hoje = DateTime.now();
  final atendimentos = _atendimentos.where((atendimento) {
    final data = atendimento.dataHora;
    return data.year == hoje.year &&
        data.month == hoje.month &&
        data.day == hoje.day;
  }).toList();

  atendimentos.sort((a, b) => a.dataHora.compareTo(b.dataHora));
  return atendimentos;
}
