import '../../shared/atendimento/atendimento.dart';

// IDs fictícios apenas para teste. No banco, usaremos os IDs dos registros.
final _hoje = DateTime.now();
final _atendimentos = [
  Atendimento(
    id: 1,
    pacienteId: 1,
    clinicaId: 1,
    nomePaciente: 'Maria Silva',
    nomeClinica: 'Clínica Saúde',
    dataHora: DateTime(_hoje.year, _hoje.month, _hoje.day, 14),
    sala: '3',
    duracaoMinutos: 60,
    status: 'Agendado',
  ),
  Atendimento(
    id: 2,
    pacienteId: 2,
    clinicaId: 2,
    nomePaciente: 'João Pedro',
    nomeClinica: 'Clínica Multicare',
    dataHora: DateTime(_hoje.year, _hoje.month, _hoje.day, 16),
    sala: '2',
    duracaoMinutos: 60,
    status: 'Agendado',
  ),
];

// Depois, substituir por uma consulta ao banco que filtre pela data.
Stream<List<Atendimento>> criarStreamAgenda(DateTime data) {
  final atendimentos = _atendimentos.where((atendimento) {
    final dia = atendimento.dataHora;
    return dia.year == data.year &&
        dia.month == data.month &&
        dia.day == data.day;
  }).toList();

  atendimentos.sort((a, b) => a.dataHora.compareTo(b.dataHora));
  return Stream.value(atendimentos);
}
