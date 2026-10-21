import 'dart:async';
import './atendimento.dart';

final _hoje = DateTime.now();
final _atendimentos = <Atendimento>[
  Atendimento(
    id: 1,
    pacienteId: 1,
    clinicaId: 1,
    nomePaciente: 'Ana Carolina',
    nomeClinica: 'Clínica mente sã',
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
    nomeClinica: 'Clínica mente sã',
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
    nomeClinica: 'Clínica multicare',
    dataHora: DateTime(_hoje.year, _hoje.month, _hoje.day, 16),
    sala: '2',
    duracaoMinutos: 60,
    status: 'Agendado',
  ),
];

int _proximoId = 4;
final _alteracoes = StreamController<void>.broadcast();

void adicionarAtendimentoEmMemoria({
  required int pacienteId,
  required int? clinicaId,
  required String nomePaciente,
  required String nomeClinica,
  required DateTime dataHora,
  required int duracaoMinutos,
  required bool emitirNotaFiscal,
}) {
  _atendimentos.add(Atendimento(
    id: _proximoId++,
    pacienteId: pacienteId,
    clinicaId: clinicaId,
    nomePaciente: nomePaciente,
    nomeClinica: nomeClinica,
    dataHora: dataHora,
    sala: '',
    duracaoMinutos: duracaoMinutos,
    status: 'Agendado',
    emitirNotaFiscal: emitirNotaFiscal,
  ));

  _alteracoes.add(null);
}

Atendimento? atendimentoPorIdEmMemoria(int id) {
  for (final atendimento in _atendimentos) {
    if (atendimento.id == id) return atendimento;
  }
  return null;
}

bool atualizarAtendimentoEmMemoria({
  required int id,
  required int pacienteId,
  required int? clinicaId,
  required String nomePaciente,
  required String nomeClinica,
  required DateTime dataHora,
  required int duracaoMinutos,
  required bool emitirNotaFiscal,
}) {
  final indice = _atendimentos.indexWhere((item) => item.id == id);
  if (indice == -1 || _atendimentos[indice].status != 'Agendado') return false;
  final anterior = _atendimentos[indice];

  _atendimentos[indice] = Atendimento(
    id: anterior.id,
    pacienteId: pacienteId,
    clinicaId: clinicaId,
    nomePaciente: nomePaciente,
    nomeClinica: clinicaId == null ? '' : nomeClinica,
    dataHora: dataHora,
    sala: anterior.clinicaId == clinicaId ? anterior.sala : '',
    duracaoMinutos: duracaoMinutos,
    status: anterior.status,
    emitirNotaFiscal: emitirNotaFiscal,
    notaFiscalEmitida: anterior.notaFiscalEmitida,
  );
  _alteracoes.add(null);
  return true;
}

bool cancelarAtendimentoEmMemoria(int id) {
  final indice = _atendimentos.indexWhere((item) => item.id == id);
  if (indice == -1 || _atendimentos[indice].status != 'Agendado') return false;

  _atendimentos[indice] = _atendimentos[indice].copyWith(status: 'Cancelado');
  _alteracoes.add(null);
  return true;
}

bool concluirAtendimentoEmMemoria(int id) {
  final indice = _atendimentos.indexWhere((item) => item.id == id);
  if (indice == -1 || _atendimentos[indice].status != 'Agendado') return false;

  _atendimentos[indice] = _atendimentos[indice].copyWith(status: 'Concluído');
  _alteracoes.add(null);
  return true;
}

bool marcarNotaFiscalEmitidaEmMemoria(int id) {
  final indice = _atendimentos.indexWhere((item) => item.id == id);
  if (indice == -1 || !_atendimentos[indice].notaFiscalPendente) return false;

  _atendimentos[indice] =
      _atendimentos[indice].copyWith(notaFiscalEmitida: true);
  _alteracoes.add(null);
  return true;
}

List<Atendimento> notasFiscaisEmMemoria({
  int? pacienteId,
  bool apenasPendentes = false,
}) {
  final notas = _atendimentos.where((atendimento) {
    return atendimento.status != 'Cancelado' &&
        atendimento.emitirNotaFiscal &&
        (pacienteId == null || atendimento.pacienteId == pacienteId) &&
        (!apenasPendentes || atendimento.notaFiscalPendente);
  }).toList();
  notas.sort((a, b) => a.dataHora.compareTo(b.dataHora));
  return notas;
}

List<Atendimento> atendimentosDoDia(DateTime data) {
  final atendimentos = _atendimentos.where((atendimento) {
    final dia = atendimento.dataHora;
    return atendimento.status != 'Cancelado' &&
        dia.year == data.year &&
        dia.month == data.month &&
        dia.day == data.day;
  }).toList();

  atendimentos.sort((a, b) => a.dataHora.compareTo(b.dataHora));
  return atendimentos;
}

Stream<T> observarDadosEmMemoria<T>(T Function() consultar) {
  return Stream<T>.multi((controller) {
    final assinatura = _alteracoes.stream.listen((_) {
      controller.add(consultar());
    });

    controller.onCancel = assinatura.cancel;
    controller.add(consultar());
  });
}
