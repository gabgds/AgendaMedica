import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'app_database.g.dart';

class Medicos extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nome => text()();
  TextColumn get email => text()();
  TextColumn get senha => text()();
}

class Clinicas extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get medicoId => integer().references(Medicos, #id)();
  TextColumn get nome => text()();
  TextColumn get endereco => text()();
}

class Pacientes extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get medicoId => integer().references(Medicos, #id)();
  IntColumn get clinicaId => integer().nullable().references(Clinicas, #id)(); 
  TextColumn get nomeCompleto => text()();
  DateTimeColumn get dataNascimento => dateTime()();
  TextColumn get cpf => text().unique()();
  TextColumn get endereco => text()();
  TextColumn get email => text()();
  TextColumn get telefone => text()();
}

class Agendamentos extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get pacienteId => integer().references(Pacientes, #id)();
  IntColumn get clinicaId => integer().nullable().references(Clinicas, #id)();
  DateTimeColumn get dataHora => dateTime()();
  TextColumn get sala => text()();
  IntColumn get duracaoMinutos => integer()();
  TextColumn get status => text()(); 
}

class NotasFiscais extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get pacienteId => integer().references(Pacientes, #id)();
  IntColumn get agendamentoId => integer().nullable().references(Agendamentos, #id)();
  RealColumn get valor => real()(); 
  BoolColumn get emitida => boolean().withDefault(const Constant(false))();
  DateTimeColumn get dataEmissao => dateTime().nullable()();
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db_agenda.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}

@DriftDatabase(tables: [Medicos, Clinicas, Pacientes, Agendamentos, NotasFiscais])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  Future<int> inserirMedico(MedicosCompanion medico) => into(medicos).insert(medico);
  Future<int> inserirClinica(ClinicasCompanion clinica) => into(clinicas).insert(clinica);
  Future<int> inserirPaciente(PacientesCompanion paciente) => into(pacientes).insert(paciente);
  Future<int> inserirAgendamento(AgendamentosCompanion agendamento) => into(agendamentos).insert(agendamento);
  Future<int> inserirNotaFiscal(NotasFiscaisCompanion notaFiscal) => into(notasFiscais).insert(notaFiscal);
}