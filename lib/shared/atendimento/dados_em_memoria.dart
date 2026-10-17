import 'dart:async';
import './atendimento.dart';

// Lista provisória compartilhada entre Agenda e Início.
// Fica somente na memória e é reiniciada ao encerrar o aplicativo.
// Isso vai ser substituído por back-end com Drift
final _hoje = DateTime.now();
final _atendimentos = <Atendimento>[
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

// IDs temporários para identificar os novos atendimentos durante a execução.
int _proximoId = 4;
final _alteracoes = StreamController<void>.broadcast();

void adicionarAtendimentoEmMemoria({
  required int pacienteId,
  required int? clinicaId,
  required String nomePaciente,
  required String nomeClinica,
  required DateTime dataHora,
  required int duracaoMinutos,
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
  ));

  // Avisa os streams para atualizarem a lista, os contadores e o próximo card.
  _alteracoes.add(null);
}

List<Atendimento> atendimentosDoDia(DateTime data) {
  final atendimentos = _atendimentos.where((atendimento) {
    final dia = atendimento.dataHora;
    return dia.year == data.year &&
        dia.month == data.month &&
        dia.day == data.day;
  }).toList();

  atendimentos.sort((a, b) => a.dataHora.compareTo(b.dataHora));
  return atendimentos;
}

// Entrega os dados atuais ao ouvir o stream e novamente quando a lista mudar.
// Cada ouvinte tem sua assinatura, cancelada ao sair da tela.
Stream<T> observarDadosEmMemoria<T>(T Function() consultar) {
  return Stream<T>.multi((controller) {
    final assinatura = _alteracoes.stream.listen((_) {
      controller.add(consultar());
    });

    controller.onCancel = assinatura.cancel;
    controller.add(consultar());
  });
}
