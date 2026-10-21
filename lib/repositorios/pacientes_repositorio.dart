import 'package:drift/drift.dart';
import 'package:pex/database/app_database.dart';
import 'package:pex/database/banco.dart';
import 'package:pex/paginas/pacientes/formulario_paciente/novo_paciente.dart';
import 'package:pex/paginas/pacientes/paciente.dart';
import 'package:pex/shared/usuario/sessao.dart';

class CpfJaCadastrado implements Exception {
  const CpfJaCadastrado();

  @override
  String toString() => 'Já existe um paciente com este CPF.';
}

class PacienteComNotaPendente implements Exception {
  const PacienteComNotaPendente();

  @override
  String toString() =>
      'Este paciente tem nota fiscal pendente. Registre a emissão antes de removê-lo.';
}

Paciente _paraPaciente(TypedResult linha) {
  final paciente = linha.readTable(banco.pacientes);
  final clinica = linha.readTableOrNull(banco.clinicas);
  return Paciente(
    id: paciente.id,
    nome: paciente.nomeCompleto,
    telefone: paciente.telefone,
    dataNascimento: paciente.dataNascimento,
    cpf: paciente.cpf,
    endereco: paciente.endereco,
    email: paciente.email,
    clinicaId: paciente.clinicaId,
    nomeClinica: clinica?.nome ?? '',
  );
}

JoinedSelectStatement _consultaPacientes() {
  return banco.select(banco.pacientes).join([
    leftOuterJoin(
      banco.clinicas,
      banco.clinicas.id.equalsExp(banco.pacientes.clinicaId),
    ),
  ])
    ..where(banco.pacientes.medicoId.equals(medicoLogadoId))
    ..orderBy([OrderingTerm.asc(banco.pacientes.nomeCompleto)]);
}

Stream<List<Paciente>> observarPacientes() {
  return _consultaPacientes()
      .watch()
      .map((linhas) => linhas.map(_paraPaciente).toList());
}

Future<List<Paciente>> listarPacientes() => observarPacientes().first;

Stream<Paciente?> observarPaciente(int id) {
  final consulta = _consultaPacientes()
    ..where(banco.pacientes.id.equals(id));
  return consulta.watchSingleOrNull().map(
        (linha) => linha == null ? null : _paraPaciente(linha),
      );
}

Future<Paciente?> buscarPaciente(int id) => observarPaciente(id).first;

Future<void> _validarCpf(String cpf, {int? ignorarId}) async {
  final consulta = banco.select(banco.pacientes)
    ..where((p) => p.medicoId.equals(medicoLogadoId) & p.cpf.equals(cpf));
  final existentes = await consulta.get();
  if (existentes.any((p) => p.id != ignorarId)) throw const CpfJaCadastrado();
}

Future<Paciente> adicionarPaciente(NovoPaciente dados) async {
  await _validarCpf(dados.cpf);
  final id = await banco.into(banco.pacientes).insert(
        PacientesCompanion.insert(
          medicoId: medicoLogadoId,
          clinicaId: Value(dados.clinicaId),
          nomeCompleto: dados.nome,
          dataNascimento: dados.dataNascimento,
          cpf: dados.cpf,
          endereco: dados.endereco,
          email: dados.email,
          telefone: dados.telefone,
        ),
      );
  return (await buscarPaciente(id))!;
}

Future<Paciente> atualizarPaciente(int id, NovoPaciente dados) async {
  await _validarCpf(dados.cpf, ignorarId: id);
  await (banco.update(banco.pacientes)
        ..where((p) => p.id.equals(id) & p.medicoId.equals(medicoLogadoId)))
      .write(PacientesCompanion(
    clinicaId: Value(dados.clinicaId),
    nomeCompleto: Value(dados.nome),
    dataNascimento: Value(dados.dataNascimento),
    cpf: Value(dados.cpf),
    endereco: Value(dados.endereco),
    email: Value(dados.email),
    telefone: Value(dados.telefone),
  ));
  return (await buscarPaciente(id))!;
}

Future<void> removerPaciente(int id) {
  return banco.transaction(() async {
    final pendentes = await (banco.select(banco.notasFiscais).join([
      innerJoin(
        banco.agendamentos,
        banco.agendamentos.id.equalsExp(banco.notasFiscais.agendamentoId),
      ),
    ])
          ..where(banco.notasFiscais.pacienteId.equals(id) &
              banco.notasFiscais.emitida.equals(false) &
              banco.agendamentos.status.equals(StatusAgendamento.concluido)))
        .get();
    if (pendentes.isNotEmpty) throw const PacienteComNotaPendente();

    await (banco.delete(banco.notasFiscais)
          ..where((n) => n.pacienteId.equals(id)))
        .go();
    await (banco.delete(banco.agendamentos)
          ..where((a) => a.pacienteId.equals(id)))
        .go();
    await (banco.delete(banco.pacientes)
          ..where((p) => p.id.equals(id) & p.medicoId.equals(medicoLogadoId)))
        .go();
  });
}
