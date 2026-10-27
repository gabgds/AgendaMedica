import 'package:drift/native.dart';
import 'package:pex/database/app_database.dart';
import 'package:sqlite3/sqlite3.dart';

AppDatabase abrirBancoAntigo(int versao) {
  final sqlite = sqlite3.openInMemory();
  final usuario = versao == 1 ? 'email' : 'usuario';
  sqlite.execute('''
    CREATE TABLE medicos (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      nome TEXT NOT NULL, $usuario TEXT NOT NULL UNIQUE, senha TEXT NOT NULL
    );
    CREATE TABLE clinicas (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      medico_id INTEGER NOT NULL REFERENCES medicos(id),
      nome TEXT NOT NULL, endereco TEXT NOT NULL
    );
    CREATE TABLE pacientes (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      medico_id INTEGER NOT NULL REFERENCES medicos(id),
      clinica_id INTEGER REFERENCES clinicas(id),
      nome_completo TEXT NOT NULL, data_nascimento INTEGER NOT NULL,
      cpf TEXT NOT NULL, endereco TEXT NOT NULL,
      email TEXT NOT NULL, telefone TEXT NOT NULL,
      UNIQUE (medico_id, cpf)
    );
    CREATE TABLE agendamentos (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      paciente_id INTEGER NOT NULL REFERENCES pacientes(id),
      clinica_id INTEGER REFERENCES clinicas(id),
      data_hora INTEGER NOT NULL, sala TEXT NOT NULL DEFAULT '',
      duracao_minutos INTEGER NOT NULL, status TEXT NOT NULL DEFAULT 'Agendado'
    );
    CREATE TABLE notas_fiscais (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      paciente_id INTEGER NOT NULL REFERENCES pacientes(id),
      agendamento_id INTEGER UNIQUE REFERENCES agendamentos(id),
      valor REAL NOT NULL DEFAULT 0, emitida INTEGER NOT NULL DEFAULT 0,
      data_emissao INTEGER
    );
    INSERT INTO medicos VALUES (1, 'Dr. Carlos', 'carlos', 'hash preservado');
    INSERT INTO clinicas VALUES (10, 1, 'Centro', 'Rua A');
    INSERT INTO clinicas VALUES (11, 1, 'Norte', 'Rua B');
    INSERT INTO pacientes VALUES
      (20, 1, 10, 'Maria', 643161600, '12345678901', 'Rua C', 'maria@exemplo.com', '47999998888'),
      (21, 1, NULL, 'João', 643161600, '98765432100', 'Rua D', 'joao@exemplo.com', '47988887777');
    INSERT INTO agendamentos VALUES
      (100, 20, 11, 1787842800, '3', 60, 'Agendado'),
      (101, 20, NULL, 1787846400, '', 45, 'Cancelado'),
      (102, 21, 10, 1787850000, '1', 30, 'Concluído');
    INSERT INTO notas_fiscais VALUES (500, 21, 102, 120, 0, NULL);
    PRAGMA user_version = $versao;
    PRAGMA foreign_keys = ON;
  ''');
  return AppDatabase.paraTeste(NativeDatabase.opened(sqlite));
}
