import 'package:drift/drift.dart';
import 'package:pex/database/app_database.dart';
import 'package:pex/database/banco.dart';
import 'package:pex/paginas/agenda/formulario_agenda/novo_agendamento.dart';
import 'package:pex/shared/atendimento/atendimento.dart';
import 'package:pex/shared/usuario/sessao.dart';

JoinedSelectStatement _consultaAtendimentos() {
  return banco.select(banco.agendamentos).join([
    innerJoin(
      banco.pacientes,
      banco.pacientes.id.equalsExp(banco.agendamentos.pacienteId),
    ),
    leftOuterJoin(
      banco.clinicas,
      banco.clinicas.id.equalsExp(banco.agendamentos.clinicaId),
    ),
    leftOuterJoin(
      banco.notasFiscais,
      banco.notasFiscais.agendamentoId.equalsExp(banco.agendamentos.id),
    ),
  ])
    ..where(banco.pacientes.medicoId.equals(medicoLogadoId))
    ..orderBy([OrderingTerm.asc(banco.agendamentos.dataHora)]);
}

Atendimento _paraAtendimento(TypedResult linha) {
  final agendamento = linha.readTable(banco.agendamentos);
  final paciente = linha.readTable(banco.pacientes);
  final clinica = linha.readTableOrNull(banco.clinicas);
  final nota = linha.readTableOrNull(banco.notasFiscais);
  return Atendimento(
    id: agendamento.id,
    pacienteId: agendamento.pacienteId,
    clinicaId: agendamento.clinicaId,
    nomePaciente: paciente.nomeCompleto,
    nomeClinica: clinica?.nome ?? '',
    dataHora: agendamento.dataHora,
    sala: agendamento.sala,
    duracaoMinutos: agendamento.duracaoMinutos,
    status: agendamento.status,
    emitirNotaFiscal: nota != null,
    notaFiscalEmitida: nota?.emitida ?? false,
  );
}

Stream<List<Atendimento>> _observar(JoinedSelectStatement consulta) {
  return consulta
      .watch()
      .map((linhas) => linhas.map(_paraAtendimento).toList());
}

Stream<List<Atendimento>> observarAtendimentosDoDia(DateTime data) {
  final inicio = DateTime(data.year, data.month, data.day);
  final fim = DateTime(data.year, data.month, data.day + 1);
  final consulta = _consultaAtendimentos()
    ..where(banco.agendamentos.dataHora.isBiggerOrEqualValue(inicio) &
        banco.agendamentos.dataHora.isSmallerThanValue(fim) &
        banco.agendamentos.status.equals(StatusAgendamento.cancelado).not());
  return _observar(consulta);
}

Stream<Atendimento?> observarAtendimento(int id) {
  final consulta = _consultaAtendimentos()
    ..where(banco.agendamentos.id.equals(id));
  return consulta.watchSingleOrNull().map(
        (linha) => linha == null ? null : _paraAtendimento(linha),
      );
}

Future<Atendimento?> buscarAtendimento(int id) =>
    observarAtendimento(id).first;

Stream<List<Atendimento>> observarNotasFiscais({
  int? pacienteId,
  bool apenasPendentes = false,
}) {
  final consulta = _consultaAtendimentos()
    ..where(banco.notasFiscais.id.isNotNull() &
        banco.agendamentos.status.equals(StatusAgendamento.cancelado).not());
  if (pacienteId != null) {
    consulta.where(banco.agendamentos.pacienteId.equals(pacienteId));
  }
  if (apenasPendentes) {
    consulta.where(
      banco.agendamentos.status.equals(StatusAgendamento.concluido) &
          banco.notasFiscais.emitida.equals(false),
    );
  }
  return _observar(consulta);
}

Future<void> _validarVinculos(NovoAgendamento dados) async {
  final paciente = await (banco.select(banco.pacientes)
        ..where((p) =>
            p.id.equals(dados.pacienteId) & p.medicoId.equals(medicoLogadoId)))
      .getSingleOrNull();
  if (paciente == null) throw ArgumentError('Paciente não encontrado.');

  final clinicaId = dados.clinicaId;
  if (clinicaId == null) return;
  final clinica = await (banco.select(banco.clinicas)
        ..where((c) =>
            c.id.equals(clinicaId) & c.medicoId.equals(medicoLogadoId)))
      .getSingleOrNull();
  if (clinica == null) throw ArgumentError('Clínica não encontrada.');
}

Future<int> adicionarAtendimento(NovoAgendamento dados) async {
  await _validarVinculos(dados);
  return banco.transaction(() async {
    final id = await banco.into(banco.agendamentos).insert(
          AgendamentosCompanion.insert(
            pacienteId: dados.pacienteId,
            clinicaId: Value(dados.clinicaId),
            dataHora: dados.dataHora,
            sala: Value(dados.clinicaId == null ? '' : dados.sala.trim()),
            duracaoMinutos: dados.duracaoMinutos,
          ),
        );
    if (dados.emitirNotaFiscal) {
      await banco.into(banco.notasFiscais).insert(NotasFiscaisCompanion.insert(
            pacienteId: dados.pacienteId,
            agendamentoId: Value(id),
          ));
    }
    return id;
  });
}

Future<bool> _estaAgendado(int id) async {
  final atendimento = await buscarAtendimento(id);
  return atendimento?.status == StatusAgendamento.agendado;
}

Future<bool> atualizarAtendimento(int id, NovoAgendamento dados) async {
  if (!await _estaAgendado(id)) return false;
  await _validarVinculos(dados);

  await banco.transaction(() async {
    await (banco.update(banco.agendamentos)..where((a) => a.id.equals(id)))
        .write(AgendamentosCompanion(
      pacienteId: Value(dados.pacienteId),
      clinicaId: Value(dados.clinicaId),
      dataHora: Value(dados.dataHora),
      sala: Value(dados.clinicaId == null ? '' : dados.sala.trim()),
      duracaoMinutos: Value(dados.duracaoMinutos),
    ));

    final notas = banco.notasFiscais;
    if (dados.emitirNotaFiscal) {
      await banco.into(notas).insert(
            NotasFiscaisCompanion.insert(
              pacienteId: dados.pacienteId,
              agendamentoId: Value(id),
            ),
            onConflict: DoUpdate(
              (_) => NotasFiscaisCompanion(pacienteId: Value(dados.pacienteId)),
              target: [notas.agendamentoId],
            ),
          );
    } else {
      await (banco.delete(notas)..where((n) => n.agendamentoId.equals(id)))
          .go();
    }
  });
  return true;
}

Future<bool> _alterarStatus(int id, String status) async {
  if (!await _estaAgendado(id)) return false;
  await (banco.update(banco.agendamentos)..where((a) => a.id.equals(id)))
      .write(AgendamentosCompanion(status: Value(status)));
  return true;
}

Future<bool> cancelarAtendimento(int id) =>
    _alterarStatus(id, StatusAgendamento.cancelado);

Future<bool> concluirAtendimento(int id) =>
    _alterarStatus(id, StatusAgendamento.concluido);

Future<bool> marcarNotaFiscalEmitida(int agendamentoId) async {
  final atendimento = await buscarAtendimento(agendamentoId);
  if (atendimento == null || !atendimento.notaFiscalPendente) return false;

  await (banco.update(banco.notasFiscais)
        ..where((n) => n.agendamentoId.equals(agendamentoId)))
      .write(NotasFiscaisCompanion(
    emitida: const Value(true),
    dataEmissao: Value(DateTime.now()),
  ));
  return true;
}
