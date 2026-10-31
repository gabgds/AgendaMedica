import 'package:drift/drift.dart';
import 'package:pex/database/app_database.dart';
import 'package:pex/database/banco.dart';
import 'package:pex/paginas/clinicas/clinica.dart';
import 'package:pex/paginas/clinicas/formulario_clinica/nova_clinica.dart';
import 'package:pex/shared/usuario/sessao.dart';

class ClinicaComAgendamentos implements Exception {
  const ClinicaComAgendamentos();

  @override
  String toString() =>
      'Esta clínica possui agendamentos não cancelados e não pode ser removida.';
}

Clinica _paraClinica(ClinicaRegistro linha) =>
    Clinica(id: linha.id, nome: linha.nome, endereco: linha.endereco);

Stream<List<Clinica>> observarClinicas() {
  final consulta = banco.select(banco.clinicas)
    ..where((c) => c.medicoId.equals(medicoLogadoId))
    ..orderBy([(c) => OrderingTerm.asc(c.nome)]);
  return consulta.watch().map((linhas) => linhas.map(_paraClinica).toList());
}

Future<List<Clinica>> listarClinicas() => observarClinicas().first;

Future<Clinica> adicionarClinica(NovaClinica dados) async {
  final id = await banco.into(banco.clinicas).insert(ClinicasCompanion.insert(
        medicoId: medicoLogadoId,
        nome: dados.nome,
        endereco: dados.endereco,
      ));
  return dados.paraClinica(id: id);
}

Future<Clinica> atualizarClinica(int id, NovaClinica dados) async {
  await (banco.update(banco.clinicas)
        ..where((c) => c.id.equals(id) & c.medicoId.equals(medicoLogadoId)))
      .write(ClinicasCompanion(
    nome: Value(dados.nome),
    endereco: Value(dados.endereco),
  ));
  return dados.paraClinica(id: id);
}

Future<void> removerClinica(int id) {
  final medicoId = medicoLogadoId;
  return banco.transaction(() async {
    final clinica = await (banco.select(banco.clinicas)
          ..where((c) => c.id.equals(id) & c.medicoId.equals(medicoId)))
        .getSingleOrNull();
    if (clinica == null) return;

    final agendamentos = await (banco.select(banco.agendamentos)
          ..where(
            (a) =>
                a.clinicaId.equals(id) &
                a.status.equals(StatusAgendamento.cancelado).not(),
          )
          ..limit(1))
        .get();
    if (agendamentos.isNotEmpty) throw const ClinicaComAgendamentos();

    // Os cancelados permanecem no banco, sem impedir a exclusão da clínica
    // nem deixar uma chave estrangeira apontando para um cadastro removido.
    await (banco.update(banco.agendamentos)
          ..where((a) => a.clinicaId.equals(id)))
        .write(const AgendamentosCompanion(clinicaId: Value(null)));
    await (banco.delete(
      banco.clinicas,
    )..where((c) => c.id.equals(id) & c.medicoId.equals(medicoId)))
        .go();
  });
}
