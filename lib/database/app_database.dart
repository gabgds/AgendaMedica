import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'status_agendamento.dart';

export 'status_agendamento.dart';

part 'app_database.g.dart';

@DataClassName('MedicoRegistro')
class Medicos extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nome => text()();
  TextColumn get usuario => text().unique()();
  TextColumn get senha => text()();
}

@DataClassName('ClinicaRegistro')
class Clinicas extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get medicoId => integer().references(Medicos, #id)();
  TextColumn get nome => text()();
  TextColumn get endereco => text()();
}

@DataClassName('PacienteRegistro')
class Pacientes extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get medicoId => integer().references(Medicos, #id)();
  IntColumn get clinicaId => integer().nullable().references(Clinicas, #id)();
  TextColumn get nomeCompleto => text()();
  DateTimeColumn get dataNascimento => dateTime()();
  TextColumn get cpf => text()();
  TextColumn get endereco => text()();
  TextColumn get email => text()();
  TextColumn get telefone => text()();

  @override
  List<Set<Column>> get uniqueKeys => [
        {medicoId, cpf},
      ];
}

@DataClassName('AgendamentoRegistro')
class Agendamentos extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get pacienteId => integer().references(Pacientes, #id)();
  IntColumn get clinicaId => integer().nullable().references(Clinicas, #id)();
  DateTimeColumn get dataHora => dateTime()();
  TextColumn get sala => text().withDefault(const Constant(''))();
  IntColumn get duracaoMinutos => integer()();
  TextColumn get status =>
      text().withDefault(const Constant(StatusAgendamento.agendado))();
}

@DataClassName('NotaFiscalRegistro')
class NotasFiscais extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get pacienteId => integer().references(Pacientes, #id)();
  IntColumn get agendamentoId =>
      integer().nullable().unique().references(Agendamentos, #id)();
  RealColumn get valor => real().withDefault(const Constant(0))();
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

  AppDatabase.paraTeste(super.executor);

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onUpgrade: (m, de, para) async {
          if (de < 2) {
            await m.renameColumn(medicos, 'email', medicos.usuario);
          }
        },
        beforeOpen: (detalhes) async {
          await customStatement('PRAGMA foreign_keys = ON');
        },
      );
}
