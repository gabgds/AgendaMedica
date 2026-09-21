// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $MedicosTable extends Medicos with TableInfo<$MedicosTable, Medico> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MedicosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nomeMeta = const VerificationMeta('nome');
  @override
  late final GeneratedColumn<String> nome = GeneratedColumn<String>(
      'nome', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
      'email', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _senhaMeta = const VerificationMeta('senha');
  @override
  late final GeneratedColumn<String> senha = GeneratedColumn<String>(
      'senha', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, nome, email, senha];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'medicos';
  @override
  VerificationContext validateIntegrity(Insertable<Medico> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('nome')) {
      context.handle(
          _nomeMeta, nome.isAcceptableOrUnknown(data['nome']!, _nomeMeta));
    } else if (isInserting) {
      context.missing(_nomeMeta);
    }
    if (data.containsKey('email')) {
      context.handle(
          _emailMeta, email.isAcceptableOrUnknown(data['email']!, _emailMeta));
    } else if (isInserting) {
      context.missing(_emailMeta);
    }
    if (data.containsKey('senha')) {
      context.handle(
          _senhaMeta, senha.isAcceptableOrUnknown(data['senha']!, _senhaMeta));
    } else if (isInserting) {
      context.missing(_senhaMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Medico map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Medico(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      nome: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}nome'])!,
      email: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}email'])!,
      senha: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}senha'])!,
    );
  }

  @override
  $MedicosTable createAlias(String alias) {
    return $MedicosTable(attachedDatabase, alias);
  }
}

class Medico extends DataClass implements Insertable<Medico> {
  final int id;
  final String nome;
  final String email;
  final String senha;
  const Medico(
      {required this.id,
      required this.nome,
      required this.email,
      required this.senha});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['nome'] = Variable<String>(nome);
    map['email'] = Variable<String>(email);
    map['senha'] = Variable<String>(senha);
    return map;
  }

  MedicosCompanion toCompanion(bool nullToAbsent) {
    return MedicosCompanion(
      id: Value(id),
      nome: Value(nome),
      email: Value(email),
      senha: Value(senha),
    );
  }

  factory Medico.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Medico(
      id: serializer.fromJson<int>(json['id']),
      nome: serializer.fromJson<String>(json['nome']),
      email: serializer.fromJson<String>(json['email']),
      senha: serializer.fromJson<String>(json['senha']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nome': serializer.toJson<String>(nome),
      'email': serializer.toJson<String>(email),
      'senha': serializer.toJson<String>(senha),
    };
  }

  Medico copyWith({int? id, String? nome, String? email, String? senha}) =>
      Medico(
        id: id ?? this.id,
        nome: nome ?? this.nome,
        email: email ?? this.email,
        senha: senha ?? this.senha,
      );
  Medico copyWithCompanion(MedicosCompanion data) {
    return Medico(
      id: data.id.present ? data.id.value : this.id,
      nome: data.nome.present ? data.nome.value : this.nome,
      email: data.email.present ? data.email.value : this.email,
      senha: data.senha.present ? data.senha.value : this.senha,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Medico(')
          ..write('id: $id, ')
          ..write('nome: $nome, ')
          ..write('email: $email, ')
          ..write('senha: $senha')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, nome, email, senha);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Medico &&
          other.id == this.id &&
          other.nome == this.nome &&
          other.email == this.email &&
          other.senha == this.senha);
}

class MedicosCompanion extends UpdateCompanion<Medico> {
  final Value<int> id;
  final Value<String> nome;
  final Value<String> email;
  final Value<String> senha;
  const MedicosCompanion({
    this.id = const Value.absent(),
    this.nome = const Value.absent(),
    this.email = const Value.absent(),
    this.senha = const Value.absent(),
  });
  MedicosCompanion.insert({
    this.id = const Value.absent(),
    required String nome,
    required String email,
    required String senha,
  })  : nome = Value(nome),
        email = Value(email),
        senha = Value(senha);
  static Insertable<Medico> custom({
    Expression<int>? id,
    Expression<String>? nome,
    Expression<String>? email,
    Expression<String>? senha,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nome != null) 'nome': nome,
      if (email != null) 'email': email,
      if (senha != null) 'senha': senha,
    });
  }

  MedicosCompanion copyWith(
      {Value<int>? id,
      Value<String>? nome,
      Value<String>? email,
      Value<String>? senha}) {
    return MedicosCompanion(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      email: email ?? this.email,
      senha: senha ?? this.senha,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nome.present) {
      map['nome'] = Variable<String>(nome.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (senha.present) {
      map['senha'] = Variable<String>(senha.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MedicosCompanion(')
          ..write('id: $id, ')
          ..write('nome: $nome, ')
          ..write('email: $email, ')
          ..write('senha: $senha')
          ..write(')'))
        .toString();
  }
}

class $ClinicasTable extends Clinicas with TableInfo<$ClinicasTable, Clinica> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ClinicasTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _medicoIdMeta =
      const VerificationMeta('medicoId');
  @override
  late final GeneratedColumn<int> medicoId = GeneratedColumn<int>(
      'medico_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES medicos (id)'));
  static const VerificationMeta _nomeMeta = const VerificationMeta('nome');
  @override
  late final GeneratedColumn<String> nome = GeneratedColumn<String>(
      'nome', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _enderecoMeta =
      const VerificationMeta('endereco');
  @override
  late final GeneratedColumn<String> endereco = GeneratedColumn<String>(
      'endereco', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, medicoId, nome, endereco];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'clinicas';
  @override
  VerificationContext validateIntegrity(Insertable<Clinica> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('medico_id')) {
      context.handle(_medicoIdMeta,
          medicoId.isAcceptableOrUnknown(data['medico_id']!, _medicoIdMeta));
    } else if (isInserting) {
      context.missing(_medicoIdMeta);
    }
    if (data.containsKey('nome')) {
      context.handle(
          _nomeMeta, nome.isAcceptableOrUnknown(data['nome']!, _nomeMeta));
    } else if (isInserting) {
      context.missing(_nomeMeta);
    }
    if (data.containsKey('endereco')) {
      context.handle(_enderecoMeta,
          endereco.isAcceptableOrUnknown(data['endereco']!, _enderecoMeta));
    } else if (isInserting) {
      context.missing(_enderecoMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Clinica map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Clinica(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      medicoId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}medico_id'])!,
      nome: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}nome'])!,
      endereco: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}endereco'])!,
    );
  }

  @override
  $ClinicasTable createAlias(String alias) {
    return $ClinicasTable(attachedDatabase, alias);
  }
}

class Clinica extends DataClass implements Insertable<Clinica> {
  final int id;
  final int medicoId;
  final String nome;
  final String endereco;
  const Clinica(
      {required this.id,
      required this.medicoId,
      required this.nome,
      required this.endereco});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['medico_id'] = Variable<int>(medicoId);
    map['nome'] = Variable<String>(nome);
    map['endereco'] = Variable<String>(endereco);
    return map;
  }

  ClinicasCompanion toCompanion(bool nullToAbsent) {
    return ClinicasCompanion(
      id: Value(id),
      medicoId: Value(medicoId),
      nome: Value(nome),
      endereco: Value(endereco),
    );
  }

  factory Clinica.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Clinica(
      id: serializer.fromJson<int>(json['id']),
      medicoId: serializer.fromJson<int>(json['medicoId']),
      nome: serializer.fromJson<String>(json['nome']),
      endereco: serializer.fromJson<String>(json['endereco']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'medicoId': serializer.toJson<int>(medicoId),
      'nome': serializer.toJson<String>(nome),
      'endereco': serializer.toJson<String>(endereco),
    };
  }

  Clinica copyWith({int? id, int? medicoId, String? nome, String? endereco}) =>
      Clinica(
        id: id ?? this.id,
        medicoId: medicoId ?? this.medicoId,
        nome: nome ?? this.nome,
        endereco: endereco ?? this.endereco,
      );
  Clinica copyWithCompanion(ClinicasCompanion data) {
    return Clinica(
      id: data.id.present ? data.id.value : this.id,
      medicoId: data.medicoId.present ? data.medicoId.value : this.medicoId,
      nome: data.nome.present ? data.nome.value : this.nome,
      endereco: data.endereco.present ? data.endereco.value : this.endereco,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Clinica(')
          ..write('id: $id, ')
          ..write('medicoId: $medicoId, ')
          ..write('nome: $nome, ')
          ..write('endereco: $endereco')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, medicoId, nome, endereco);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Clinica &&
          other.id == this.id &&
          other.medicoId == this.medicoId &&
          other.nome == this.nome &&
          other.endereco == this.endereco);
}

class ClinicasCompanion extends UpdateCompanion<Clinica> {
  final Value<int> id;
  final Value<int> medicoId;
  final Value<String> nome;
  final Value<String> endereco;
  const ClinicasCompanion({
    this.id = const Value.absent(),
    this.medicoId = const Value.absent(),
    this.nome = const Value.absent(),
    this.endereco = const Value.absent(),
  });
  ClinicasCompanion.insert({
    this.id = const Value.absent(),
    required int medicoId,
    required String nome,
    required String endereco,
  })  : medicoId = Value(medicoId),
        nome = Value(nome),
        endereco = Value(endereco);
  static Insertable<Clinica> custom({
    Expression<int>? id,
    Expression<int>? medicoId,
    Expression<String>? nome,
    Expression<String>? endereco,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (medicoId != null) 'medico_id': medicoId,
      if (nome != null) 'nome': nome,
      if (endereco != null) 'endereco': endereco,
    });
  }

  ClinicasCompanion copyWith(
      {Value<int>? id,
      Value<int>? medicoId,
      Value<String>? nome,
      Value<String>? endereco}) {
    return ClinicasCompanion(
      id: id ?? this.id,
      medicoId: medicoId ?? this.medicoId,
      nome: nome ?? this.nome,
      endereco: endereco ?? this.endereco,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (medicoId.present) {
      map['medico_id'] = Variable<int>(medicoId.value);
    }
    if (nome.present) {
      map['nome'] = Variable<String>(nome.value);
    }
    if (endereco.present) {
      map['endereco'] = Variable<String>(endereco.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ClinicasCompanion(')
          ..write('id: $id, ')
          ..write('medicoId: $medicoId, ')
          ..write('nome: $nome, ')
          ..write('endereco: $endereco')
          ..write(')'))
        .toString();
  }
}

class $PacientesTable extends Pacientes
    with TableInfo<$PacientesTable, Paciente> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PacientesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _medicoIdMeta =
      const VerificationMeta('medicoId');
  @override
  late final GeneratedColumn<int> medicoId = GeneratedColumn<int>(
      'medico_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES medicos (id)'));
  static const VerificationMeta _clinicaIdMeta =
      const VerificationMeta('clinicaId');
  @override
  late final GeneratedColumn<int> clinicaId = GeneratedColumn<int>(
      'clinica_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES clinicas (id)'));
  static const VerificationMeta _nomeCompletoMeta =
      const VerificationMeta('nomeCompleto');
  @override
  late final GeneratedColumn<String> nomeCompleto = GeneratedColumn<String>(
      'nome_completo', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _dataNascimentoMeta =
      const VerificationMeta('dataNascimento');
  @override
  late final GeneratedColumn<DateTime> dataNascimento =
      GeneratedColumn<DateTime>('data_nascimento', aliasedName, false,
          type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _cpfMeta = const VerificationMeta('cpf');
  @override
  late final GeneratedColumn<String> cpf = GeneratedColumn<String>(
      'cpf', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _enderecoMeta =
      const VerificationMeta('endereco');
  @override
  late final GeneratedColumn<String> endereco = GeneratedColumn<String>(
      'endereco', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
      'email', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _telefoneMeta =
      const VerificationMeta('telefone');
  @override
  late final GeneratedColumn<String> telefone = GeneratedColumn<String>(
      'telefone', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        medicoId,
        clinicaId,
        nomeCompleto,
        dataNascimento,
        cpf,
        endereco,
        email,
        telefone
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pacientes';
  @override
  VerificationContext validateIntegrity(Insertable<Paciente> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('medico_id')) {
      context.handle(_medicoIdMeta,
          medicoId.isAcceptableOrUnknown(data['medico_id']!, _medicoIdMeta));
    } else if (isInserting) {
      context.missing(_medicoIdMeta);
    }
    if (data.containsKey('clinica_id')) {
      context.handle(_clinicaIdMeta,
          clinicaId.isAcceptableOrUnknown(data['clinica_id']!, _clinicaIdMeta));
    }
    if (data.containsKey('nome_completo')) {
      context.handle(
          _nomeCompletoMeta,
          nomeCompleto.isAcceptableOrUnknown(
              data['nome_completo']!, _nomeCompletoMeta));
    } else if (isInserting) {
      context.missing(_nomeCompletoMeta);
    }
    if (data.containsKey('data_nascimento')) {
      context.handle(
          _dataNascimentoMeta,
          dataNascimento.isAcceptableOrUnknown(
              data['data_nascimento']!, _dataNascimentoMeta));
    } else if (isInserting) {
      context.missing(_dataNascimentoMeta);
    }
    if (data.containsKey('cpf')) {
      context.handle(
          _cpfMeta, cpf.isAcceptableOrUnknown(data['cpf']!, _cpfMeta));
    } else if (isInserting) {
      context.missing(_cpfMeta);
    }
    if (data.containsKey('endereco')) {
      context.handle(_enderecoMeta,
          endereco.isAcceptableOrUnknown(data['endereco']!, _enderecoMeta));
    } else if (isInserting) {
      context.missing(_enderecoMeta);
    }
    if (data.containsKey('email')) {
      context.handle(
          _emailMeta, email.isAcceptableOrUnknown(data['email']!, _emailMeta));
    } else if (isInserting) {
      context.missing(_emailMeta);
    }
    if (data.containsKey('telefone')) {
      context.handle(_telefoneMeta,
          telefone.isAcceptableOrUnknown(data['telefone']!, _telefoneMeta));
    } else if (isInserting) {
      context.missing(_telefoneMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Paciente map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Paciente(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      medicoId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}medico_id'])!,
      clinicaId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}clinica_id']),
      nomeCompleto: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}nome_completo'])!,
      dataNascimento: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}data_nascimento'])!,
      cpf: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}cpf'])!,
      endereco: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}endereco'])!,
      email: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}email'])!,
      telefone: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}telefone'])!,
    );
  }

  @override
  $PacientesTable createAlias(String alias) {
    return $PacientesTable(attachedDatabase, alias);
  }
}

class Paciente extends DataClass implements Insertable<Paciente> {
  final int id;
  final int medicoId;
  final int? clinicaId;
  final String nomeCompleto;
  final DateTime dataNascimento;
  final String cpf;
  final String endereco;
  final String email;
  final String telefone;
  const Paciente(
      {required this.id,
      required this.medicoId,
      this.clinicaId,
      required this.nomeCompleto,
      required this.dataNascimento,
      required this.cpf,
      required this.endereco,
      required this.email,
      required this.telefone});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['medico_id'] = Variable<int>(medicoId);
    if (!nullToAbsent || clinicaId != null) {
      map['clinica_id'] = Variable<int>(clinicaId);
    }
    map['nome_completo'] = Variable<String>(nomeCompleto);
    map['data_nascimento'] = Variable<DateTime>(dataNascimento);
    map['cpf'] = Variable<String>(cpf);
    map['endereco'] = Variable<String>(endereco);
    map['email'] = Variable<String>(email);
    map['telefone'] = Variable<String>(telefone);
    return map;
  }

  PacientesCompanion toCompanion(bool nullToAbsent) {
    return PacientesCompanion(
      id: Value(id),
      medicoId: Value(medicoId),
      clinicaId: clinicaId == null && nullToAbsent
          ? const Value.absent()
          : Value(clinicaId),
      nomeCompleto: Value(nomeCompleto),
      dataNascimento: Value(dataNascimento),
      cpf: Value(cpf),
      endereco: Value(endereco),
      email: Value(email),
      telefone: Value(telefone),
    );
  }

  factory Paciente.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Paciente(
      id: serializer.fromJson<int>(json['id']),
      medicoId: serializer.fromJson<int>(json['medicoId']),
      clinicaId: serializer.fromJson<int?>(json['clinicaId']),
      nomeCompleto: serializer.fromJson<String>(json['nomeCompleto']),
      dataNascimento: serializer.fromJson<DateTime>(json['dataNascimento']),
      cpf: serializer.fromJson<String>(json['cpf']),
      endereco: serializer.fromJson<String>(json['endereco']),
      email: serializer.fromJson<String>(json['email']),
      telefone: serializer.fromJson<String>(json['telefone']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'medicoId': serializer.toJson<int>(medicoId),
      'clinicaId': serializer.toJson<int?>(clinicaId),
      'nomeCompleto': serializer.toJson<String>(nomeCompleto),
      'dataNascimento': serializer.toJson<DateTime>(dataNascimento),
      'cpf': serializer.toJson<String>(cpf),
      'endereco': serializer.toJson<String>(endereco),
      'email': serializer.toJson<String>(email),
      'telefone': serializer.toJson<String>(telefone),
    };
  }

  Paciente copyWith(
          {int? id,
          int? medicoId,
          Value<int?> clinicaId = const Value.absent(),
          String? nomeCompleto,
          DateTime? dataNascimento,
          String? cpf,
          String? endereco,
          String? email,
          String? telefone}) =>
      Paciente(
        id: id ?? this.id,
        medicoId: medicoId ?? this.medicoId,
        clinicaId: clinicaId.present ? clinicaId.value : this.clinicaId,
        nomeCompleto: nomeCompleto ?? this.nomeCompleto,
        dataNascimento: dataNascimento ?? this.dataNascimento,
        cpf: cpf ?? this.cpf,
        endereco: endereco ?? this.endereco,
        email: email ?? this.email,
        telefone: telefone ?? this.telefone,
      );
  Paciente copyWithCompanion(PacientesCompanion data) {
    return Paciente(
      id: data.id.present ? data.id.value : this.id,
      medicoId: data.medicoId.present ? data.medicoId.value : this.medicoId,
      clinicaId: data.clinicaId.present ? data.clinicaId.value : this.clinicaId,
      nomeCompleto: data.nomeCompleto.present
          ? data.nomeCompleto.value
          : this.nomeCompleto,
      dataNascimento: data.dataNascimento.present
          ? data.dataNascimento.value
          : this.dataNascimento,
      cpf: data.cpf.present ? data.cpf.value : this.cpf,
      endereco: data.endereco.present ? data.endereco.value : this.endereco,
      email: data.email.present ? data.email.value : this.email,
      telefone: data.telefone.present ? data.telefone.value : this.telefone,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Paciente(')
          ..write('id: $id, ')
          ..write('medicoId: $medicoId, ')
          ..write('clinicaId: $clinicaId, ')
          ..write('nomeCompleto: $nomeCompleto, ')
          ..write('dataNascimento: $dataNascimento, ')
          ..write('cpf: $cpf, ')
          ..write('endereco: $endereco, ')
          ..write('email: $email, ')
          ..write('telefone: $telefone')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, medicoId, clinicaId, nomeCompleto,
      dataNascimento, cpf, endereco, email, telefone);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Paciente &&
          other.id == this.id &&
          other.medicoId == this.medicoId &&
          other.clinicaId == this.clinicaId &&
          other.nomeCompleto == this.nomeCompleto &&
          other.dataNascimento == this.dataNascimento &&
          other.cpf == this.cpf &&
          other.endereco == this.endereco &&
          other.email == this.email &&
          other.telefone == this.telefone);
}

class PacientesCompanion extends UpdateCompanion<Paciente> {
  final Value<int> id;
  final Value<int> medicoId;
  final Value<int?> clinicaId;
  final Value<String> nomeCompleto;
  final Value<DateTime> dataNascimento;
  final Value<String> cpf;
  final Value<String> endereco;
  final Value<String> email;
  final Value<String> telefone;
  const PacientesCompanion({
    this.id = const Value.absent(),
    this.medicoId = const Value.absent(),
    this.clinicaId = const Value.absent(),
    this.nomeCompleto = const Value.absent(),
    this.dataNascimento = const Value.absent(),
    this.cpf = const Value.absent(),
    this.endereco = const Value.absent(),
    this.email = const Value.absent(),
    this.telefone = const Value.absent(),
  });
  PacientesCompanion.insert({
    this.id = const Value.absent(),
    required int medicoId,
    this.clinicaId = const Value.absent(),
    required String nomeCompleto,
    required DateTime dataNascimento,
    required String cpf,
    required String endereco,
    required String email,
    required String telefone,
  })  : medicoId = Value(medicoId),
        nomeCompleto = Value(nomeCompleto),
        dataNascimento = Value(dataNascimento),
        cpf = Value(cpf),
        endereco = Value(endereco),
        email = Value(email),
        telefone = Value(telefone);
  static Insertable<Paciente> custom({
    Expression<int>? id,
    Expression<int>? medicoId,
    Expression<int>? clinicaId,
    Expression<String>? nomeCompleto,
    Expression<DateTime>? dataNascimento,
    Expression<String>? cpf,
    Expression<String>? endereco,
    Expression<String>? email,
    Expression<String>? telefone,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (medicoId != null) 'medico_id': medicoId,
      if (clinicaId != null) 'clinica_id': clinicaId,
      if (nomeCompleto != null) 'nome_completo': nomeCompleto,
      if (dataNascimento != null) 'data_nascimento': dataNascimento,
      if (cpf != null) 'cpf': cpf,
      if (endereco != null) 'endereco': endereco,
      if (email != null) 'email': email,
      if (telefone != null) 'telefone': telefone,
    });
  }

  PacientesCompanion copyWith(
      {Value<int>? id,
      Value<int>? medicoId,
      Value<int?>? clinicaId,
      Value<String>? nomeCompleto,
      Value<DateTime>? dataNascimento,
      Value<String>? cpf,
      Value<String>? endereco,
      Value<String>? email,
      Value<String>? telefone}) {
    return PacientesCompanion(
      id: id ?? this.id,
      medicoId: medicoId ?? this.medicoId,
      clinicaId: clinicaId ?? this.clinicaId,
      nomeCompleto: nomeCompleto ?? this.nomeCompleto,
      dataNascimento: dataNascimento ?? this.dataNascimento,
      cpf: cpf ?? this.cpf,
      endereco: endereco ?? this.endereco,
      email: email ?? this.email,
      telefone: telefone ?? this.telefone,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (medicoId.present) {
      map['medico_id'] = Variable<int>(medicoId.value);
    }
    if (clinicaId.present) {
      map['clinica_id'] = Variable<int>(clinicaId.value);
    }
    if (nomeCompleto.present) {
      map['nome_completo'] = Variable<String>(nomeCompleto.value);
    }
    if (dataNascimento.present) {
      map['data_nascimento'] = Variable<DateTime>(dataNascimento.value);
    }
    if (cpf.present) {
      map['cpf'] = Variable<String>(cpf.value);
    }
    if (endereco.present) {
      map['endereco'] = Variable<String>(endereco.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (telefone.present) {
      map['telefone'] = Variable<String>(telefone.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PacientesCompanion(')
          ..write('id: $id, ')
          ..write('medicoId: $medicoId, ')
          ..write('clinicaId: $clinicaId, ')
          ..write('nomeCompleto: $nomeCompleto, ')
          ..write('dataNascimento: $dataNascimento, ')
          ..write('cpf: $cpf, ')
          ..write('endereco: $endereco, ')
          ..write('email: $email, ')
          ..write('telefone: $telefone')
          ..write(')'))
        .toString();
  }
}

class $AgendamentosTable extends Agendamentos
    with TableInfo<$AgendamentosTable, Agendamento> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AgendamentosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _pacienteIdMeta =
      const VerificationMeta('pacienteId');
  @override
  late final GeneratedColumn<int> pacienteId = GeneratedColumn<int>(
      'paciente_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES pacientes (id)'));
  static const VerificationMeta _clinicaIdMeta =
      const VerificationMeta('clinicaId');
  @override
  late final GeneratedColumn<int> clinicaId = GeneratedColumn<int>(
      'clinica_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES clinicas (id)'));
  static const VerificationMeta _dataHoraMeta =
      const VerificationMeta('dataHora');
  @override
  late final GeneratedColumn<DateTime> dataHora = GeneratedColumn<DateTime>(
      'data_hora', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _salaMeta = const VerificationMeta('sala');
  @override
  late final GeneratedColumn<String> sala = GeneratedColumn<String>(
      'sala', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _duracaoMinutosMeta =
      const VerificationMeta('duracaoMinutos');
  @override
  late final GeneratedColumn<int> duracaoMinutos = GeneratedColumn<int>(
      'duracao_minutos', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, pacienteId, clinicaId, dataHora, sala, duracaoMinutos, status];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'agendamentos';
  @override
  VerificationContext validateIntegrity(Insertable<Agendamento> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('paciente_id')) {
      context.handle(
          _pacienteIdMeta,
          pacienteId.isAcceptableOrUnknown(
              data['paciente_id']!, _pacienteIdMeta));
    } else if (isInserting) {
      context.missing(_pacienteIdMeta);
    }
    if (data.containsKey('clinica_id')) {
      context.handle(_clinicaIdMeta,
          clinicaId.isAcceptableOrUnknown(data['clinica_id']!, _clinicaIdMeta));
    }
    if (data.containsKey('data_hora')) {
      context.handle(_dataHoraMeta,
          dataHora.isAcceptableOrUnknown(data['data_hora']!, _dataHoraMeta));
    } else if (isInserting) {
      context.missing(_dataHoraMeta);
    }
    if (data.containsKey('sala')) {
      context.handle(
          _salaMeta, sala.isAcceptableOrUnknown(data['sala']!, _salaMeta));
    } else if (isInserting) {
      context.missing(_salaMeta);
    }
    if (data.containsKey('duracao_minutos')) {
      context.handle(
          _duracaoMinutosMeta,
          duracaoMinutos.isAcceptableOrUnknown(
              data['duracao_minutos']!, _duracaoMinutosMeta));
    } else if (isInserting) {
      context.missing(_duracaoMinutosMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Agendamento map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Agendamento(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      pacienteId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}paciente_id'])!,
      clinicaId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}clinica_id']),
      dataHora: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}data_hora'])!,
      sala: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sala'])!,
      duracaoMinutos: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}duracao_minutos'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
    );
  }

  @override
  $AgendamentosTable createAlias(String alias) {
    return $AgendamentosTable(attachedDatabase, alias);
  }
}

class Agendamento extends DataClass implements Insertable<Agendamento> {
  final int id;
  final int pacienteId;
  final int? clinicaId;
  final DateTime dataHora;
  final String sala;
  final int duracaoMinutos;
  final String status;
  const Agendamento(
      {required this.id,
      required this.pacienteId,
      this.clinicaId,
      required this.dataHora,
      required this.sala,
      required this.duracaoMinutos,
      required this.status});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['paciente_id'] = Variable<int>(pacienteId);
    if (!nullToAbsent || clinicaId != null) {
      map['clinica_id'] = Variable<int>(clinicaId);
    }
    map['data_hora'] = Variable<DateTime>(dataHora);
    map['sala'] = Variable<String>(sala);
    map['duracao_minutos'] = Variable<int>(duracaoMinutos);
    map['status'] = Variable<String>(status);
    return map;
  }

  AgendamentosCompanion toCompanion(bool nullToAbsent) {
    return AgendamentosCompanion(
      id: Value(id),
      pacienteId: Value(pacienteId),
      clinicaId: clinicaId == null && nullToAbsent
          ? const Value.absent()
          : Value(clinicaId),
      dataHora: Value(dataHora),
      sala: Value(sala),
      duracaoMinutos: Value(duracaoMinutos),
      status: Value(status),
    );
  }

  factory Agendamento.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Agendamento(
      id: serializer.fromJson<int>(json['id']),
      pacienteId: serializer.fromJson<int>(json['pacienteId']),
      clinicaId: serializer.fromJson<int?>(json['clinicaId']),
      dataHora: serializer.fromJson<DateTime>(json['dataHora']),
      sala: serializer.fromJson<String>(json['sala']),
      duracaoMinutos: serializer.fromJson<int>(json['duracaoMinutos']),
      status: serializer.fromJson<String>(json['status']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'pacienteId': serializer.toJson<int>(pacienteId),
      'clinicaId': serializer.toJson<int?>(clinicaId),
      'dataHora': serializer.toJson<DateTime>(dataHora),
      'sala': serializer.toJson<String>(sala),
      'duracaoMinutos': serializer.toJson<int>(duracaoMinutos),
      'status': serializer.toJson<String>(status),
    };
  }

  Agendamento copyWith(
          {int? id,
          int? pacienteId,
          Value<int?> clinicaId = const Value.absent(),
          DateTime? dataHora,
          String? sala,
          int? duracaoMinutos,
          String? status}) =>
      Agendamento(
        id: id ?? this.id,
        pacienteId: pacienteId ?? this.pacienteId,
        clinicaId: clinicaId.present ? clinicaId.value : this.clinicaId,
        dataHora: dataHora ?? this.dataHora,
        sala: sala ?? this.sala,
        duracaoMinutos: duracaoMinutos ?? this.duracaoMinutos,
        status: status ?? this.status,
      );
  Agendamento copyWithCompanion(AgendamentosCompanion data) {
    return Agendamento(
      id: data.id.present ? data.id.value : this.id,
      pacienteId:
          data.pacienteId.present ? data.pacienteId.value : this.pacienteId,
      clinicaId: data.clinicaId.present ? data.clinicaId.value : this.clinicaId,
      dataHora: data.dataHora.present ? data.dataHora.value : this.dataHora,
      sala: data.sala.present ? data.sala.value : this.sala,
      duracaoMinutos: data.duracaoMinutos.present
          ? data.duracaoMinutos.value
          : this.duracaoMinutos,
      status: data.status.present ? data.status.value : this.status,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Agendamento(')
          ..write('id: $id, ')
          ..write('pacienteId: $pacienteId, ')
          ..write('clinicaId: $clinicaId, ')
          ..write('dataHora: $dataHora, ')
          ..write('sala: $sala, ')
          ..write('duracaoMinutos: $duracaoMinutos, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, pacienteId, clinicaId, dataHora, sala, duracaoMinutos, status);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Agendamento &&
          other.id == this.id &&
          other.pacienteId == this.pacienteId &&
          other.clinicaId == this.clinicaId &&
          other.dataHora == this.dataHora &&
          other.sala == this.sala &&
          other.duracaoMinutos == this.duracaoMinutos &&
          other.status == this.status);
}

class AgendamentosCompanion extends UpdateCompanion<Agendamento> {
  final Value<int> id;
  final Value<int> pacienteId;
  final Value<int?> clinicaId;
  final Value<DateTime> dataHora;
  final Value<String> sala;
  final Value<int> duracaoMinutos;
  final Value<String> status;
  const AgendamentosCompanion({
    this.id = const Value.absent(),
    this.pacienteId = const Value.absent(),
    this.clinicaId = const Value.absent(),
    this.dataHora = const Value.absent(),
    this.sala = const Value.absent(),
    this.duracaoMinutos = const Value.absent(),
    this.status = const Value.absent(),
  });
  AgendamentosCompanion.insert({
    this.id = const Value.absent(),
    required int pacienteId,
    this.clinicaId = const Value.absent(),
    required DateTime dataHora,
    required String sala,
    required int duracaoMinutos,
    required String status,
  })  : pacienteId = Value(pacienteId),
        dataHora = Value(dataHora),
        sala = Value(sala),
        duracaoMinutos = Value(duracaoMinutos),
        status = Value(status);
  static Insertable<Agendamento> custom({
    Expression<int>? id,
    Expression<int>? pacienteId,
    Expression<int>? clinicaId,
    Expression<DateTime>? dataHora,
    Expression<String>? sala,
    Expression<int>? duracaoMinutos,
    Expression<String>? status,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (pacienteId != null) 'paciente_id': pacienteId,
      if (clinicaId != null) 'clinica_id': clinicaId,
      if (dataHora != null) 'data_hora': dataHora,
      if (sala != null) 'sala': sala,
      if (duracaoMinutos != null) 'duracao_minutos': duracaoMinutos,
      if (status != null) 'status': status,
    });
  }

  AgendamentosCompanion copyWith(
      {Value<int>? id,
      Value<int>? pacienteId,
      Value<int?>? clinicaId,
      Value<DateTime>? dataHora,
      Value<String>? sala,
      Value<int>? duracaoMinutos,
      Value<String>? status}) {
    return AgendamentosCompanion(
      id: id ?? this.id,
      pacienteId: pacienteId ?? this.pacienteId,
      clinicaId: clinicaId ?? this.clinicaId,
      dataHora: dataHora ?? this.dataHora,
      sala: sala ?? this.sala,
      duracaoMinutos: duracaoMinutos ?? this.duracaoMinutos,
      status: status ?? this.status,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (pacienteId.present) {
      map['paciente_id'] = Variable<int>(pacienteId.value);
    }
    if (clinicaId.present) {
      map['clinica_id'] = Variable<int>(clinicaId.value);
    }
    if (dataHora.present) {
      map['data_hora'] = Variable<DateTime>(dataHora.value);
    }
    if (sala.present) {
      map['sala'] = Variable<String>(sala.value);
    }
    if (duracaoMinutos.present) {
      map['duracao_minutos'] = Variable<int>(duracaoMinutos.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AgendamentosCompanion(')
          ..write('id: $id, ')
          ..write('pacienteId: $pacienteId, ')
          ..write('clinicaId: $clinicaId, ')
          ..write('dataHora: $dataHora, ')
          ..write('sala: $sala, ')
          ..write('duracaoMinutos: $duracaoMinutos, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }
}

class $NotasFiscaisTable extends NotasFiscais
    with TableInfo<$NotasFiscaisTable, NotasFiscai> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NotasFiscaisTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _pacienteIdMeta =
      const VerificationMeta('pacienteId');
  @override
  late final GeneratedColumn<int> pacienteId = GeneratedColumn<int>(
      'paciente_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES pacientes (id)'));
  static const VerificationMeta _agendamentoIdMeta =
      const VerificationMeta('agendamentoId');
  @override
  late final GeneratedColumn<int> agendamentoId = GeneratedColumn<int>(
      'agendamento_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES agendamentos (id)'));
  static const VerificationMeta _valorMeta = const VerificationMeta('valor');
  @override
  late final GeneratedColumn<double> valor = GeneratedColumn<double>(
      'valor', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _emitidaMeta =
      const VerificationMeta('emitida');
  @override
  late final GeneratedColumn<bool> emitida = GeneratedColumn<bool>(
      'emitida', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("emitida" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _dataEmissaoMeta =
      const VerificationMeta('dataEmissao');
  @override
  late final GeneratedColumn<DateTime> dataEmissao = GeneratedColumn<DateTime>(
      'data_emissao', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, pacienteId, agendamentoId, valor, emitida, dataEmissao];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'notas_fiscais';
  @override
  VerificationContext validateIntegrity(Insertable<NotasFiscai> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('paciente_id')) {
      context.handle(
          _pacienteIdMeta,
          pacienteId.isAcceptableOrUnknown(
              data['paciente_id']!, _pacienteIdMeta));
    } else if (isInserting) {
      context.missing(_pacienteIdMeta);
    }
    if (data.containsKey('agendamento_id')) {
      context.handle(
          _agendamentoIdMeta,
          agendamentoId.isAcceptableOrUnknown(
              data['agendamento_id']!, _agendamentoIdMeta));
    }
    if (data.containsKey('valor')) {
      context.handle(
          _valorMeta, valor.isAcceptableOrUnknown(data['valor']!, _valorMeta));
    } else if (isInserting) {
      context.missing(_valorMeta);
    }
    if (data.containsKey('emitida')) {
      context.handle(_emitidaMeta,
          emitida.isAcceptableOrUnknown(data['emitida']!, _emitidaMeta));
    }
    if (data.containsKey('data_emissao')) {
      context.handle(
          _dataEmissaoMeta,
          dataEmissao.isAcceptableOrUnknown(
              data['data_emissao']!, _dataEmissaoMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  NotasFiscai map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return NotasFiscai(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      pacienteId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}paciente_id'])!,
      agendamentoId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}agendamento_id']),
      valor: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}valor'])!,
      emitida: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}emitida'])!,
      dataEmissao: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}data_emissao']),
    );
  }

  @override
  $NotasFiscaisTable createAlias(String alias) {
    return $NotasFiscaisTable(attachedDatabase, alias);
  }
}

class NotasFiscai extends DataClass implements Insertable<NotasFiscai> {
  final int id;
  final int pacienteId;
  final int? agendamentoId;
  final double valor;
  final bool emitida;
  final DateTime? dataEmissao;
  const NotasFiscai(
      {required this.id,
      required this.pacienteId,
      this.agendamentoId,
      required this.valor,
      required this.emitida,
      this.dataEmissao});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['paciente_id'] = Variable<int>(pacienteId);
    if (!nullToAbsent || agendamentoId != null) {
      map['agendamento_id'] = Variable<int>(agendamentoId);
    }
    map['valor'] = Variable<double>(valor);
    map['emitida'] = Variable<bool>(emitida);
    if (!nullToAbsent || dataEmissao != null) {
      map['data_emissao'] = Variable<DateTime>(dataEmissao);
    }
    return map;
  }

  NotasFiscaisCompanion toCompanion(bool nullToAbsent) {
    return NotasFiscaisCompanion(
      id: Value(id),
      pacienteId: Value(pacienteId),
      agendamentoId: agendamentoId == null && nullToAbsent
          ? const Value.absent()
          : Value(agendamentoId),
      valor: Value(valor),
      emitida: Value(emitida),
      dataEmissao: dataEmissao == null && nullToAbsent
          ? const Value.absent()
          : Value(dataEmissao),
    );
  }

  factory NotasFiscai.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return NotasFiscai(
      id: serializer.fromJson<int>(json['id']),
      pacienteId: serializer.fromJson<int>(json['pacienteId']),
      agendamentoId: serializer.fromJson<int?>(json['agendamentoId']),
      valor: serializer.fromJson<double>(json['valor']),
      emitida: serializer.fromJson<bool>(json['emitida']),
      dataEmissao: serializer.fromJson<DateTime?>(json['dataEmissao']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'pacienteId': serializer.toJson<int>(pacienteId),
      'agendamentoId': serializer.toJson<int?>(agendamentoId),
      'valor': serializer.toJson<double>(valor),
      'emitida': serializer.toJson<bool>(emitida),
      'dataEmissao': serializer.toJson<DateTime?>(dataEmissao),
    };
  }

  NotasFiscai copyWith(
          {int? id,
          int? pacienteId,
          Value<int?> agendamentoId = const Value.absent(),
          double? valor,
          bool? emitida,
          Value<DateTime?> dataEmissao = const Value.absent()}) =>
      NotasFiscai(
        id: id ?? this.id,
        pacienteId: pacienteId ?? this.pacienteId,
        agendamentoId:
            agendamentoId.present ? agendamentoId.value : this.agendamentoId,
        valor: valor ?? this.valor,
        emitida: emitida ?? this.emitida,
        dataEmissao: dataEmissao.present ? dataEmissao.value : this.dataEmissao,
      );
  NotasFiscai copyWithCompanion(NotasFiscaisCompanion data) {
    return NotasFiscai(
      id: data.id.present ? data.id.value : this.id,
      pacienteId:
          data.pacienteId.present ? data.pacienteId.value : this.pacienteId,
      agendamentoId: data.agendamentoId.present
          ? data.agendamentoId.value
          : this.agendamentoId,
      valor: data.valor.present ? data.valor.value : this.valor,
      emitida: data.emitida.present ? data.emitida.value : this.emitida,
      dataEmissao:
          data.dataEmissao.present ? data.dataEmissao.value : this.dataEmissao,
    );
  }

  @override
  String toString() {
    return (StringBuffer('NotasFiscai(')
          ..write('id: $id, ')
          ..write('pacienteId: $pacienteId, ')
          ..write('agendamentoId: $agendamentoId, ')
          ..write('valor: $valor, ')
          ..write('emitida: $emitida, ')
          ..write('dataEmissao: $dataEmissao')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, pacienteId, agendamentoId, valor, emitida, dataEmissao);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is NotasFiscai &&
          other.id == this.id &&
          other.pacienteId == this.pacienteId &&
          other.agendamentoId == this.agendamentoId &&
          other.valor == this.valor &&
          other.emitida == this.emitida &&
          other.dataEmissao == this.dataEmissao);
}

class NotasFiscaisCompanion extends UpdateCompanion<NotasFiscai> {
  final Value<int> id;
  final Value<int> pacienteId;
  final Value<int?> agendamentoId;
  final Value<double> valor;
  final Value<bool> emitida;
  final Value<DateTime?> dataEmissao;
  const NotasFiscaisCompanion({
    this.id = const Value.absent(),
    this.pacienteId = const Value.absent(),
    this.agendamentoId = const Value.absent(),
    this.valor = const Value.absent(),
    this.emitida = const Value.absent(),
    this.dataEmissao = const Value.absent(),
  });
  NotasFiscaisCompanion.insert({
    this.id = const Value.absent(),
    required int pacienteId,
    this.agendamentoId = const Value.absent(),
    required double valor,
    this.emitida = const Value.absent(),
    this.dataEmissao = const Value.absent(),
  })  : pacienteId = Value(pacienteId),
        valor = Value(valor);
  static Insertable<NotasFiscai> custom({
    Expression<int>? id,
    Expression<int>? pacienteId,
    Expression<int>? agendamentoId,
    Expression<double>? valor,
    Expression<bool>? emitida,
    Expression<DateTime>? dataEmissao,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (pacienteId != null) 'paciente_id': pacienteId,
      if (agendamentoId != null) 'agendamento_id': agendamentoId,
      if (valor != null) 'valor': valor,
      if (emitida != null) 'emitida': emitida,
      if (dataEmissao != null) 'data_emissao': dataEmissao,
    });
  }

  NotasFiscaisCompanion copyWith(
      {Value<int>? id,
      Value<int>? pacienteId,
      Value<int?>? agendamentoId,
      Value<double>? valor,
      Value<bool>? emitida,
      Value<DateTime?>? dataEmissao}) {
    return NotasFiscaisCompanion(
      id: id ?? this.id,
      pacienteId: pacienteId ?? this.pacienteId,
      agendamentoId: agendamentoId ?? this.agendamentoId,
      valor: valor ?? this.valor,
      emitida: emitida ?? this.emitida,
      dataEmissao: dataEmissao ?? this.dataEmissao,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (pacienteId.present) {
      map['paciente_id'] = Variable<int>(pacienteId.value);
    }
    if (agendamentoId.present) {
      map['agendamento_id'] = Variable<int>(agendamentoId.value);
    }
    if (valor.present) {
      map['valor'] = Variable<double>(valor.value);
    }
    if (emitida.present) {
      map['emitida'] = Variable<bool>(emitida.value);
    }
    if (dataEmissao.present) {
      map['data_emissao'] = Variable<DateTime>(dataEmissao.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NotasFiscaisCompanion(')
          ..write('id: $id, ')
          ..write('pacienteId: $pacienteId, ')
          ..write('agendamentoId: $agendamentoId, ')
          ..write('valor: $valor, ')
          ..write('emitida: $emitida, ')
          ..write('dataEmissao: $dataEmissao')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $MedicosTable medicos = $MedicosTable(this);
  late final $ClinicasTable clinicas = $ClinicasTable(this);
  late final $PacientesTable pacientes = $PacientesTable(this);
  late final $AgendamentosTable agendamentos = $AgendamentosTable(this);
  late final $NotasFiscaisTable notasFiscais = $NotasFiscaisTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [medicos, clinicas, pacientes, agendamentos, notasFiscais];
}

typedef $$MedicosTableCreateCompanionBuilder = MedicosCompanion Function({
  Value<int> id,
  required String nome,
  required String email,
  required String senha,
});
typedef $$MedicosTableUpdateCompanionBuilder = MedicosCompanion Function({
  Value<int> id,
  Value<String> nome,
  Value<String> email,
  Value<String> senha,
});

final class $$MedicosTableReferences
    extends BaseReferences<_$AppDatabase, $MedicosTable, Medico> {
  $$MedicosTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ClinicasTable, List<Clinica>> _clinicasRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.clinicas,
          aliasName: 'medicos__id__clinicas__medico_id');

  $$ClinicasTableProcessedTableManager get clinicasRefs {
    final manager = $$ClinicasTableTableManager($_db, $_db.clinicas)
        .filter((f) => f.medicoId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_clinicasRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$PacientesTable, List<Paciente>>
      _pacientesRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.pacientes,
              aliasName: 'medicos__id__pacientes__medico_id');

  $$PacientesTableProcessedTableManager get pacientesRefs {
    final manager = $$PacientesTableTableManager($_db, $_db.pacientes)
        .filter((f) => f.medicoId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_pacientesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$MedicosTableFilterComposer
    extends Composer<_$AppDatabase, $MedicosTable> {
  $$MedicosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nome => $composableBuilder(
      column: $table.nome, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get senha => $composableBuilder(
      column: $table.senha, builder: (column) => ColumnFilters(column));

  Expression<bool> clinicasRefs(
      Expression<bool> Function($$ClinicasTableFilterComposer f) f) {
    final $$ClinicasTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.clinicas,
        getReferencedColumn: (t) => t.medicoId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ClinicasTableFilterComposer(
              $db: $db,
              $table: $db.clinicas,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> pacientesRefs(
      Expression<bool> Function($$PacientesTableFilterComposer f) f) {
    final $$PacientesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.pacientes,
        getReferencedColumn: (t) => t.medicoId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PacientesTableFilterComposer(
              $db: $db,
              $table: $db.pacientes,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$MedicosTableOrderingComposer
    extends Composer<_$AppDatabase, $MedicosTable> {
  $$MedicosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nome => $composableBuilder(
      column: $table.nome, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get senha => $composableBuilder(
      column: $table.senha, builder: (column) => ColumnOrderings(column));
}

class $$MedicosTableAnnotationComposer
    extends Composer<_$AppDatabase, $MedicosTable> {
  $$MedicosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nome =>
      $composableBuilder(column: $table.nome, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get senha =>
      $composableBuilder(column: $table.senha, builder: (column) => column);

  Expression<T> clinicasRefs<T extends Object>(
      Expression<T> Function($$ClinicasTableAnnotationComposer a) f) {
    final $$ClinicasTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.clinicas,
        getReferencedColumn: (t) => t.medicoId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ClinicasTableAnnotationComposer(
              $db: $db,
              $table: $db.clinicas,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> pacientesRefs<T extends Object>(
      Expression<T> Function($$PacientesTableAnnotationComposer a) f) {
    final $$PacientesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.pacientes,
        getReferencedColumn: (t) => t.medicoId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PacientesTableAnnotationComposer(
              $db: $db,
              $table: $db.pacientes,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$MedicosTableTableManager extends RootTableManager<
    _$AppDatabase,
    $MedicosTable,
    Medico,
    $$MedicosTableFilterComposer,
    $$MedicosTableOrderingComposer,
    $$MedicosTableAnnotationComposer,
    $$MedicosTableCreateCompanionBuilder,
    $$MedicosTableUpdateCompanionBuilder,
    (Medico, $$MedicosTableReferences),
    Medico,
    PrefetchHooks Function({bool clinicasRefs, bool pacientesRefs})> {
  $$MedicosTableTableManager(_$AppDatabase db, $MedicosTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MedicosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MedicosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MedicosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> nome = const Value.absent(),
            Value<String> email = const Value.absent(),
            Value<String> senha = const Value.absent(),
          }) =>
              MedicosCompanion(
            id: id,
            nome: nome,
            email: email,
            senha: senha,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String nome,
            required String email,
            required String senha,
          }) =>
              MedicosCompanion.insert(
            id: id,
            nome: nome,
            email: email,
            senha: senha,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$MedicosTable, Medico>(table),
                    $$MedicosTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {clinicasRefs = false, pacientesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (clinicasRefs) db.clinicas,
                if (pacientesRefs) db.pacientes
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (clinicasRefs)
                    await $_getPrefetchedData<Medico, $MedicosTable, Clinica>(
                        currentTable: table,
                        referencedTable:
                            $$MedicosTableReferences._clinicasRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$MedicosTableReferences(db, table, p0)
                                .clinicasRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.medicoId == item.id),
                        typedResults: items),
                  if (pacientesRefs)
                    await $_getPrefetchedData<Medico, $MedicosTable, Paciente>(
                        currentTable: table,
                        referencedTable:
                            $$MedicosTableReferences._pacientesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$MedicosTableReferences(db, table, p0)
                                .pacientesRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.medicoId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$MedicosTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $MedicosTable,
    Medico,
    $$MedicosTableFilterComposer,
    $$MedicosTableOrderingComposer,
    $$MedicosTableAnnotationComposer,
    $$MedicosTableCreateCompanionBuilder,
    $$MedicosTableUpdateCompanionBuilder,
    (Medico, $$MedicosTableReferences),
    Medico,
    PrefetchHooks Function({bool clinicasRefs, bool pacientesRefs})>;
typedef $$ClinicasTableCreateCompanionBuilder = ClinicasCompanion Function({
  Value<int> id,
  required int medicoId,
  required String nome,
  required String endereco,
});
typedef $$ClinicasTableUpdateCompanionBuilder = ClinicasCompanion Function({
  Value<int> id,
  Value<int> medicoId,
  Value<String> nome,
  Value<String> endereco,
});

final class $$ClinicasTableReferences
    extends BaseReferences<_$AppDatabase, $ClinicasTable, Clinica> {
  $$ClinicasTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $MedicosTable _medicoIdTable(_$AppDatabase db) =>
      db.medicos.createAlias('clinicas__medico_id__medicos__id');

  $$MedicosTableProcessedTableManager get medicoId {
    final $_column = $_itemColumn<int>('medico_id')!;

    final manager = $$MedicosTableTableManager($_db, $_db.medicos)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_medicoIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$PacientesTable, List<Paciente>>
      _pacientesRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.pacientes,
              aliasName: 'clinicas__id__pacientes__clinica_id');

  $$PacientesTableProcessedTableManager get pacientesRefs {
    final manager = $$PacientesTableTableManager($_db, $_db.pacientes)
        .filter((f) => f.clinicaId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_pacientesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$AgendamentosTable, List<Agendamento>>
      _agendamentosRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.agendamentos,
              aliasName: 'clinicas__id__agendamentos__clinica_id');

  $$AgendamentosTableProcessedTableManager get agendamentosRefs {
    final manager = $$AgendamentosTableTableManager($_db, $_db.agendamentos)
        .filter((f) => f.clinicaId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_agendamentosRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$ClinicasTableFilterComposer
    extends Composer<_$AppDatabase, $ClinicasTable> {
  $$ClinicasTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nome => $composableBuilder(
      column: $table.nome, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get endereco => $composableBuilder(
      column: $table.endereco, builder: (column) => ColumnFilters(column));

  $$MedicosTableFilterComposer get medicoId {
    final $$MedicosTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.medicoId,
        referencedTable: $db.medicos,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MedicosTableFilterComposer(
              $db: $db,
              $table: $db.medicos,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> pacientesRefs(
      Expression<bool> Function($$PacientesTableFilterComposer f) f) {
    final $$PacientesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.pacientes,
        getReferencedColumn: (t) => t.clinicaId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PacientesTableFilterComposer(
              $db: $db,
              $table: $db.pacientes,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> agendamentosRefs(
      Expression<bool> Function($$AgendamentosTableFilterComposer f) f) {
    final $$AgendamentosTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.agendamentos,
        getReferencedColumn: (t) => t.clinicaId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AgendamentosTableFilterComposer(
              $db: $db,
              $table: $db.agendamentos,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ClinicasTableOrderingComposer
    extends Composer<_$AppDatabase, $ClinicasTable> {
  $$ClinicasTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nome => $composableBuilder(
      column: $table.nome, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get endereco => $composableBuilder(
      column: $table.endereco, builder: (column) => ColumnOrderings(column));

  $$MedicosTableOrderingComposer get medicoId {
    final $$MedicosTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.medicoId,
        referencedTable: $db.medicos,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MedicosTableOrderingComposer(
              $db: $db,
              $table: $db.medicos,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ClinicasTableAnnotationComposer
    extends Composer<_$AppDatabase, $ClinicasTable> {
  $$ClinicasTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nome =>
      $composableBuilder(column: $table.nome, builder: (column) => column);

  GeneratedColumn<String> get endereco =>
      $composableBuilder(column: $table.endereco, builder: (column) => column);

  $$MedicosTableAnnotationComposer get medicoId {
    final $$MedicosTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.medicoId,
        referencedTable: $db.medicos,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MedicosTableAnnotationComposer(
              $db: $db,
              $table: $db.medicos,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> pacientesRefs<T extends Object>(
      Expression<T> Function($$PacientesTableAnnotationComposer a) f) {
    final $$PacientesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.pacientes,
        getReferencedColumn: (t) => t.clinicaId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PacientesTableAnnotationComposer(
              $db: $db,
              $table: $db.pacientes,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> agendamentosRefs<T extends Object>(
      Expression<T> Function($$AgendamentosTableAnnotationComposer a) f) {
    final $$AgendamentosTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.agendamentos,
        getReferencedColumn: (t) => t.clinicaId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AgendamentosTableAnnotationComposer(
              $db: $db,
              $table: $db.agendamentos,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ClinicasTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ClinicasTable,
    Clinica,
    $$ClinicasTableFilterComposer,
    $$ClinicasTableOrderingComposer,
    $$ClinicasTableAnnotationComposer,
    $$ClinicasTableCreateCompanionBuilder,
    $$ClinicasTableUpdateCompanionBuilder,
    (Clinica, $$ClinicasTableReferences),
    Clinica,
    PrefetchHooks Function(
        {bool medicoId, bool pacientesRefs, bool agendamentosRefs})> {
  $$ClinicasTableTableManager(_$AppDatabase db, $ClinicasTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ClinicasTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ClinicasTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ClinicasTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> medicoId = const Value.absent(),
            Value<String> nome = const Value.absent(),
            Value<String> endereco = const Value.absent(),
          }) =>
              ClinicasCompanion(
            id: id,
            medicoId: medicoId,
            nome: nome,
            endereco: endereco,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int medicoId,
            required String nome,
            required String endereco,
          }) =>
              ClinicasCompanion.insert(
            id: id,
            medicoId: medicoId,
            nome: nome,
            endereco: endereco,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$ClinicasTable, Clinica>(table),
                    $$ClinicasTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {medicoId = false,
              pacientesRefs = false,
              agendamentosRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (pacientesRefs) db.pacientes,
                if (agendamentosRefs) db.agendamentos
              ],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (medicoId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.medicoId,
                    referencedTable:
                        $$ClinicasTableReferences._medicoIdTable(db),
                    referencedColumn:
                        $$ClinicasTableReferences._medicoIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (pacientesRefs)
                    await $_getPrefetchedData<Clinica, $ClinicasTable,
                            Paciente>(
                        currentTable: table,
                        referencedTable:
                            $$ClinicasTableReferences._pacientesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ClinicasTableReferences(db, table, p0)
                                .pacientesRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.clinicaId == item.id),
                        typedResults: items),
                  if (agendamentosRefs)
                    await $_getPrefetchedData<Clinica, $ClinicasTable,
                            Agendamento>(
                        currentTable: table,
                        referencedTable: $$ClinicasTableReferences
                            ._agendamentosRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ClinicasTableReferences(db, table, p0)
                                .agendamentosRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.clinicaId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$ClinicasTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ClinicasTable,
    Clinica,
    $$ClinicasTableFilterComposer,
    $$ClinicasTableOrderingComposer,
    $$ClinicasTableAnnotationComposer,
    $$ClinicasTableCreateCompanionBuilder,
    $$ClinicasTableUpdateCompanionBuilder,
    (Clinica, $$ClinicasTableReferences),
    Clinica,
    PrefetchHooks Function(
        {bool medicoId, bool pacientesRefs, bool agendamentosRefs})>;
typedef $$PacientesTableCreateCompanionBuilder = PacientesCompanion Function({
  Value<int> id,
  required int medicoId,
  Value<int?> clinicaId,
  required String nomeCompleto,
  required DateTime dataNascimento,
  required String cpf,
  required String endereco,
  required String email,
  required String telefone,
});
typedef $$PacientesTableUpdateCompanionBuilder = PacientesCompanion Function({
  Value<int> id,
  Value<int> medicoId,
  Value<int?> clinicaId,
  Value<String> nomeCompleto,
  Value<DateTime> dataNascimento,
  Value<String> cpf,
  Value<String> endereco,
  Value<String> email,
  Value<String> telefone,
});

final class $$PacientesTableReferences
    extends BaseReferences<_$AppDatabase, $PacientesTable, Paciente> {
  $$PacientesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $MedicosTable _medicoIdTable(_$AppDatabase db) =>
      db.medicos.createAlias('pacientes__medico_id__medicos__id');

  $$MedicosTableProcessedTableManager get medicoId {
    final $_column = $_itemColumn<int>('medico_id')!;

    final manager = $$MedicosTableTableManager($_db, $_db.medicos)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_medicoIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $ClinicasTable _clinicaIdTable(_$AppDatabase db) =>
      db.clinicas.createAlias('pacientes__clinica_id__clinicas__id');

  $$ClinicasTableProcessedTableManager? get clinicaId {
    final $_column = $_itemColumn<int>('clinica_id');
    if ($_column == null) return null;
    final manager = $$ClinicasTableTableManager($_db, $_db.clinicas)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_clinicaIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$AgendamentosTable, List<Agendamento>>
      _agendamentosRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.agendamentos,
              aliasName: 'pacientes__id__agendamentos__paciente_id');

  $$AgendamentosTableProcessedTableManager get agendamentosRefs {
    final manager = $$AgendamentosTableTableManager($_db, $_db.agendamentos)
        .filter((f) => f.pacienteId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_agendamentosRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$NotasFiscaisTable, List<NotasFiscai>>
      _notasFiscaisRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.notasFiscais,
              aliasName: 'pacientes__id__notas_fiscais__paciente_id');

  $$NotasFiscaisTableProcessedTableManager get notasFiscaisRefs {
    final manager = $$NotasFiscaisTableTableManager($_db, $_db.notasFiscais)
        .filter((f) => f.pacienteId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_notasFiscaisRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$PacientesTableFilterComposer
    extends Composer<_$AppDatabase, $PacientesTable> {
  $$PacientesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nomeCompleto => $composableBuilder(
      column: $table.nomeCompleto, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get dataNascimento => $composableBuilder(
      column: $table.dataNascimento,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get cpf => $composableBuilder(
      column: $table.cpf, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get endereco => $composableBuilder(
      column: $table.endereco, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get telefone => $composableBuilder(
      column: $table.telefone, builder: (column) => ColumnFilters(column));

  $$MedicosTableFilterComposer get medicoId {
    final $$MedicosTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.medicoId,
        referencedTable: $db.medicos,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MedicosTableFilterComposer(
              $db: $db,
              $table: $db.medicos,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ClinicasTableFilterComposer get clinicaId {
    final $$ClinicasTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.clinicaId,
        referencedTable: $db.clinicas,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ClinicasTableFilterComposer(
              $db: $db,
              $table: $db.clinicas,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> agendamentosRefs(
      Expression<bool> Function($$AgendamentosTableFilterComposer f) f) {
    final $$AgendamentosTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.agendamentos,
        getReferencedColumn: (t) => t.pacienteId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AgendamentosTableFilterComposer(
              $db: $db,
              $table: $db.agendamentos,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> notasFiscaisRefs(
      Expression<bool> Function($$NotasFiscaisTableFilterComposer f) f) {
    final $$NotasFiscaisTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.notasFiscais,
        getReferencedColumn: (t) => t.pacienteId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$NotasFiscaisTableFilterComposer(
              $db: $db,
              $table: $db.notasFiscais,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$PacientesTableOrderingComposer
    extends Composer<_$AppDatabase, $PacientesTable> {
  $$PacientesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nomeCompleto => $composableBuilder(
      column: $table.nomeCompleto,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get dataNascimento => $composableBuilder(
      column: $table.dataNascimento,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get cpf => $composableBuilder(
      column: $table.cpf, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get endereco => $composableBuilder(
      column: $table.endereco, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get telefone => $composableBuilder(
      column: $table.telefone, builder: (column) => ColumnOrderings(column));

  $$MedicosTableOrderingComposer get medicoId {
    final $$MedicosTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.medicoId,
        referencedTable: $db.medicos,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MedicosTableOrderingComposer(
              $db: $db,
              $table: $db.medicos,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ClinicasTableOrderingComposer get clinicaId {
    final $$ClinicasTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.clinicaId,
        referencedTable: $db.clinicas,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ClinicasTableOrderingComposer(
              $db: $db,
              $table: $db.clinicas,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PacientesTableAnnotationComposer
    extends Composer<_$AppDatabase, $PacientesTable> {
  $$PacientesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nomeCompleto => $composableBuilder(
      column: $table.nomeCompleto, builder: (column) => column);

  GeneratedColumn<DateTime> get dataNascimento => $composableBuilder(
      column: $table.dataNascimento, builder: (column) => column);

  GeneratedColumn<String> get cpf =>
      $composableBuilder(column: $table.cpf, builder: (column) => column);

  GeneratedColumn<String> get endereco =>
      $composableBuilder(column: $table.endereco, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get telefone =>
      $composableBuilder(column: $table.telefone, builder: (column) => column);

  $$MedicosTableAnnotationComposer get medicoId {
    final $$MedicosTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.medicoId,
        referencedTable: $db.medicos,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MedicosTableAnnotationComposer(
              $db: $db,
              $table: $db.medicos,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ClinicasTableAnnotationComposer get clinicaId {
    final $$ClinicasTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.clinicaId,
        referencedTable: $db.clinicas,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ClinicasTableAnnotationComposer(
              $db: $db,
              $table: $db.clinicas,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> agendamentosRefs<T extends Object>(
      Expression<T> Function($$AgendamentosTableAnnotationComposer a) f) {
    final $$AgendamentosTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.agendamentos,
        getReferencedColumn: (t) => t.pacienteId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AgendamentosTableAnnotationComposer(
              $db: $db,
              $table: $db.agendamentos,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> notasFiscaisRefs<T extends Object>(
      Expression<T> Function($$NotasFiscaisTableAnnotationComposer a) f) {
    final $$NotasFiscaisTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.notasFiscais,
        getReferencedColumn: (t) => t.pacienteId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$NotasFiscaisTableAnnotationComposer(
              $db: $db,
              $table: $db.notasFiscais,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$PacientesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PacientesTable,
    Paciente,
    $$PacientesTableFilterComposer,
    $$PacientesTableOrderingComposer,
    $$PacientesTableAnnotationComposer,
    $$PacientesTableCreateCompanionBuilder,
    $$PacientesTableUpdateCompanionBuilder,
    (Paciente, $$PacientesTableReferences),
    Paciente,
    PrefetchHooks Function(
        {bool medicoId,
        bool clinicaId,
        bool agendamentosRefs,
        bool notasFiscaisRefs})> {
  $$PacientesTableTableManager(_$AppDatabase db, $PacientesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PacientesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PacientesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PacientesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> medicoId = const Value.absent(),
            Value<int?> clinicaId = const Value.absent(),
            Value<String> nomeCompleto = const Value.absent(),
            Value<DateTime> dataNascimento = const Value.absent(),
            Value<String> cpf = const Value.absent(),
            Value<String> endereco = const Value.absent(),
            Value<String> email = const Value.absent(),
            Value<String> telefone = const Value.absent(),
          }) =>
              PacientesCompanion(
            id: id,
            medicoId: medicoId,
            clinicaId: clinicaId,
            nomeCompleto: nomeCompleto,
            dataNascimento: dataNascimento,
            cpf: cpf,
            endereco: endereco,
            email: email,
            telefone: telefone,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int medicoId,
            Value<int?> clinicaId = const Value.absent(),
            required String nomeCompleto,
            required DateTime dataNascimento,
            required String cpf,
            required String endereco,
            required String email,
            required String telefone,
          }) =>
              PacientesCompanion.insert(
            id: id,
            medicoId: medicoId,
            clinicaId: clinicaId,
            nomeCompleto: nomeCompleto,
            dataNascimento: dataNascimento,
            cpf: cpf,
            endereco: endereco,
            email: email,
            telefone: telefone,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$PacientesTable, Paciente>(table),
                    $$PacientesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {medicoId = false,
              clinicaId = false,
              agendamentosRefs = false,
              notasFiscaisRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (agendamentosRefs) db.agendamentos,
                if (notasFiscaisRefs) db.notasFiscais
              ],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (medicoId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.medicoId,
                    referencedTable:
                        $$PacientesTableReferences._medicoIdTable(db),
                    referencedColumn:
                        $$PacientesTableReferences._medicoIdTable(db).id,
                  ) as T;
                }
                if (clinicaId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.clinicaId,
                    referencedTable:
                        $$PacientesTableReferences._clinicaIdTable(db),
                    referencedColumn:
                        $$PacientesTableReferences._clinicaIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (agendamentosRefs)
                    await $_getPrefetchedData<Paciente, $PacientesTable,
                            Agendamento>(
                        currentTable: table,
                        referencedTable: $$PacientesTableReferences
                            ._agendamentosRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$PacientesTableReferences(db, table, p0)
                                .agendamentosRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.pacienteId == item.id),
                        typedResults: items),
                  if (notasFiscaisRefs)
                    await $_getPrefetchedData<Paciente, $PacientesTable,
                            NotasFiscai>(
                        currentTable: table,
                        referencedTable: $$PacientesTableReferences
                            ._notasFiscaisRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$PacientesTableReferences(db, table, p0)
                                .notasFiscaisRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.pacienteId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$PacientesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PacientesTable,
    Paciente,
    $$PacientesTableFilterComposer,
    $$PacientesTableOrderingComposer,
    $$PacientesTableAnnotationComposer,
    $$PacientesTableCreateCompanionBuilder,
    $$PacientesTableUpdateCompanionBuilder,
    (Paciente, $$PacientesTableReferences),
    Paciente,
    PrefetchHooks Function(
        {bool medicoId,
        bool clinicaId,
        bool agendamentosRefs,
        bool notasFiscaisRefs})>;
typedef $$AgendamentosTableCreateCompanionBuilder = AgendamentosCompanion
    Function({
  Value<int> id,
  required int pacienteId,
  Value<int?> clinicaId,
  required DateTime dataHora,
  required String sala,
  required int duracaoMinutos,
  required String status,
});
typedef $$AgendamentosTableUpdateCompanionBuilder = AgendamentosCompanion
    Function({
  Value<int> id,
  Value<int> pacienteId,
  Value<int?> clinicaId,
  Value<DateTime> dataHora,
  Value<String> sala,
  Value<int> duracaoMinutos,
  Value<String> status,
});

final class $$AgendamentosTableReferences
    extends BaseReferences<_$AppDatabase, $AgendamentosTable, Agendamento> {
  $$AgendamentosTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $PacientesTable _pacienteIdTable(_$AppDatabase db) =>
      db.pacientes.createAlias('agendamentos__paciente_id__pacientes__id');

  $$PacientesTableProcessedTableManager get pacienteId {
    final $_column = $_itemColumn<int>('paciente_id')!;

    final manager = $$PacientesTableTableManager($_db, $_db.pacientes)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_pacienteIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $ClinicasTable _clinicaIdTable(_$AppDatabase db) =>
      db.clinicas.createAlias('agendamentos__clinica_id__clinicas__id');

  $$ClinicasTableProcessedTableManager? get clinicaId {
    final $_column = $_itemColumn<int>('clinica_id');
    if ($_column == null) return null;
    final manager = $$ClinicasTableTableManager($_db, $_db.clinicas)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_clinicaIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$NotasFiscaisTable, List<NotasFiscai>>
      _notasFiscaisRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.notasFiscais,
              aliasName: 'agendamentos__id__notas_fiscais__agendamento_id');

  $$NotasFiscaisTableProcessedTableManager get notasFiscaisRefs {
    final manager = $$NotasFiscaisTableTableManager($_db, $_db.notasFiscais)
        .filter((f) => f.agendamentoId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_notasFiscaisRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$AgendamentosTableFilterComposer
    extends Composer<_$AppDatabase, $AgendamentosTable> {
  $$AgendamentosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get dataHora => $composableBuilder(
      column: $table.dataHora, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get sala => $composableBuilder(
      column: $table.sala, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get duracaoMinutos => $composableBuilder(
      column: $table.duracaoMinutos,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  $$PacientesTableFilterComposer get pacienteId {
    final $$PacientesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.pacienteId,
        referencedTable: $db.pacientes,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PacientesTableFilterComposer(
              $db: $db,
              $table: $db.pacientes,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ClinicasTableFilterComposer get clinicaId {
    final $$ClinicasTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.clinicaId,
        referencedTable: $db.clinicas,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ClinicasTableFilterComposer(
              $db: $db,
              $table: $db.clinicas,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> notasFiscaisRefs(
      Expression<bool> Function($$NotasFiscaisTableFilterComposer f) f) {
    final $$NotasFiscaisTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.notasFiscais,
        getReferencedColumn: (t) => t.agendamentoId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$NotasFiscaisTableFilterComposer(
              $db: $db,
              $table: $db.notasFiscais,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$AgendamentosTableOrderingComposer
    extends Composer<_$AppDatabase, $AgendamentosTable> {
  $$AgendamentosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get dataHora => $composableBuilder(
      column: $table.dataHora, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get sala => $composableBuilder(
      column: $table.sala, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get duracaoMinutos => $composableBuilder(
      column: $table.duracaoMinutos,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  $$PacientesTableOrderingComposer get pacienteId {
    final $$PacientesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.pacienteId,
        referencedTable: $db.pacientes,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PacientesTableOrderingComposer(
              $db: $db,
              $table: $db.pacientes,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ClinicasTableOrderingComposer get clinicaId {
    final $$ClinicasTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.clinicaId,
        referencedTable: $db.clinicas,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ClinicasTableOrderingComposer(
              $db: $db,
              $table: $db.clinicas,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$AgendamentosTableAnnotationComposer
    extends Composer<_$AppDatabase, $AgendamentosTable> {
  $$AgendamentosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get dataHora =>
      $composableBuilder(column: $table.dataHora, builder: (column) => column);

  GeneratedColumn<String> get sala =>
      $composableBuilder(column: $table.sala, builder: (column) => column);

  GeneratedColumn<int> get duracaoMinutos => $composableBuilder(
      column: $table.duracaoMinutos, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  $$PacientesTableAnnotationComposer get pacienteId {
    final $$PacientesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.pacienteId,
        referencedTable: $db.pacientes,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PacientesTableAnnotationComposer(
              $db: $db,
              $table: $db.pacientes,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ClinicasTableAnnotationComposer get clinicaId {
    final $$ClinicasTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.clinicaId,
        referencedTable: $db.clinicas,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ClinicasTableAnnotationComposer(
              $db: $db,
              $table: $db.clinicas,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> notasFiscaisRefs<T extends Object>(
      Expression<T> Function($$NotasFiscaisTableAnnotationComposer a) f) {
    final $$NotasFiscaisTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.notasFiscais,
        getReferencedColumn: (t) => t.agendamentoId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$NotasFiscaisTableAnnotationComposer(
              $db: $db,
              $table: $db.notasFiscais,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$AgendamentosTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AgendamentosTable,
    Agendamento,
    $$AgendamentosTableFilterComposer,
    $$AgendamentosTableOrderingComposer,
    $$AgendamentosTableAnnotationComposer,
    $$AgendamentosTableCreateCompanionBuilder,
    $$AgendamentosTableUpdateCompanionBuilder,
    (Agendamento, $$AgendamentosTableReferences),
    Agendamento,
    PrefetchHooks Function(
        {bool pacienteId, bool clinicaId, bool notasFiscaisRefs})> {
  $$AgendamentosTableTableManager(_$AppDatabase db, $AgendamentosTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AgendamentosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AgendamentosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AgendamentosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> pacienteId = const Value.absent(),
            Value<int?> clinicaId = const Value.absent(),
            Value<DateTime> dataHora = const Value.absent(),
            Value<String> sala = const Value.absent(),
            Value<int> duracaoMinutos = const Value.absent(),
            Value<String> status = const Value.absent(),
          }) =>
              AgendamentosCompanion(
            id: id,
            pacienteId: pacienteId,
            clinicaId: clinicaId,
            dataHora: dataHora,
            sala: sala,
            duracaoMinutos: duracaoMinutos,
            status: status,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int pacienteId,
            Value<int?> clinicaId = const Value.absent(),
            required DateTime dataHora,
            required String sala,
            required int duracaoMinutos,
            required String status,
          }) =>
              AgendamentosCompanion.insert(
            id: id,
            pacienteId: pacienteId,
            clinicaId: clinicaId,
            dataHora: dataHora,
            sala: sala,
            duracaoMinutos: duracaoMinutos,
            status: status,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$AgendamentosTable, Agendamento>(table),
                    $$AgendamentosTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {pacienteId = false,
              clinicaId = false,
              notasFiscaisRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (notasFiscaisRefs) db.notasFiscais],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (pacienteId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.pacienteId,
                    referencedTable:
                        $$AgendamentosTableReferences._pacienteIdTable(db),
                    referencedColumn:
                        $$AgendamentosTableReferences._pacienteIdTable(db).id,
                  ) as T;
                }
                if (clinicaId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.clinicaId,
                    referencedTable:
                        $$AgendamentosTableReferences._clinicaIdTable(db),
                    referencedColumn:
                        $$AgendamentosTableReferences._clinicaIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (notasFiscaisRefs)
                    await $_getPrefetchedData<Agendamento, $AgendamentosTable,
                            NotasFiscai>(
                        currentTable: table,
                        referencedTable: $$AgendamentosTableReferences
                            ._notasFiscaisRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$AgendamentosTableReferences(db, table, p0)
                                .notasFiscaisRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.agendamentoId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$AgendamentosTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $AgendamentosTable,
    Agendamento,
    $$AgendamentosTableFilterComposer,
    $$AgendamentosTableOrderingComposer,
    $$AgendamentosTableAnnotationComposer,
    $$AgendamentosTableCreateCompanionBuilder,
    $$AgendamentosTableUpdateCompanionBuilder,
    (Agendamento, $$AgendamentosTableReferences),
    Agendamento,
    PrefetchHooks Function(
        {bool pacienteId, bool clinicaId, bool notasFiscaisRefs})>;
typedef $$NotasFiscaisTableCreateCompanionBuilder = NotasFiscaisCompanion
    Function({
  Value<int> id,
  required int pacienteId,
  Value<int?> agendamentoId,
  required double valor,
  Value<bool> emitida,
  Value<DateTime?> dataEmissao,
});
typedef $$NotasFiscaisTableUpdateCompanionBuilder = NotasFiscaisCompanion
    Function({
  Value<int> id,
  Value<int> pacienteId,
  Value<int?> agendamentoId,
  Value<double> valor,
  Value<bool> emitida,
  Value<DateTime?> dataEmissao,
});

final class $$NotasFiscaisTableReferences
    extends BaseReferences<_$AppDatabase, $NotasFiscaisTable, NotasFiscai> {
  $$NotasFiscaisTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $PacientesTable _pacienteIdTable(_$AppDatabase db) =>
      db.pacientes.createAlias('notas_fiscais__paciente_id__pacientes__id');

  $$PacientesTableProcessedTableManager get pacienteId {
    final $_column = $_itemColumn<int>('paciente_id')!;

    final manager = $$PacientesTableTableManager($_db, $_db.pacientes)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_pacienteIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $AgendamentosTable _agendamentoIdTable(_$AppDatabase db) =>
      db.agendamentos
          .createAlias('notas_fiscais__agendamento_id__agendamentos__id');

  $$AgendamentosTableProcessedTableManager? get agendamentoId {
    final $_column = $_itemColumn<int>('agendamento_id');
    if ($_column == null) return null;
    final manager = $$AgendamentosTableTableManager($_db, $_db.agendamentos)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_agendamentoIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$NotasFiscaisTableFilterComposer
    extends Composer<_$AppDatabase, $NotasFiscaisTable> {
  $$NotasFiscaisTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get valor => $composableBuilder(
      column: $table.valor, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get emitida => $composableBuilder(
      column: $table.emitida, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get dataEmissao => $composableBuilder(
      column: $table.dataEmissao, builder: (column) => ColumnFilters(column));

  $$PacientesTableFilterComposer get pacienteId {
    final $$PacientesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.pacienteId,
        referencedTable: $db.pacientes,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PacientesTableFilterComposer(
              $db: $db,
              $table: $db.pacientes,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$AgendamentosTableFilterComposer get agendamentoId {
    final $$AgendamentosTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.agendamentoId,
        referencedTable: $db.agendamentos,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AgendamentosTableFilterComposer(
              $db: $db,
              $table: $db.agendamentos,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$NotasFiscaisTableOrderingComposer
    extends Composer<_$AppDatabase, $NotasFiscaisTable> {
  $$NotasFiscaisTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get valor => $composableBuilder(
      column: $table.valor, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get emitida => $composableBuilder(
      column: $table.emitida, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get dataEmissao => $composableBuilder(
      column: $table.dataEmissao, builder: (column) => ColumnOrderings(column));

  $$PacientesTableOrderingComposer get pacienteId {
    final $$PacientesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.pacienteId,
        referencedTable: $db.pacientes,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PacientesTableOrderingComposer(
              $db: $db,
              $table: $db.pacientes,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$AgendamentosTableOrderingComposer get agendamentoId {
    final $$AgendamentosTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.agendamentoId,
        referencedTable: $db.agendamentos,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AgendamentosTableOrderingComposer(
              $db: $db,
              $table: $db.agendamentos,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$NotasFiscaisTableAnnotationComposer
    extends Composer<_$AppDatabase, $NotasFiscaisTable> {
  $$NotasFiscaisTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get valor =>
      $composableBuilder(column: $table.valor, builder: (column) => column);

  GeneratedColumn<bool> get emitida =>
      $composableBuilder(column: $table.emitida, builder: (column) => column);

  GeneratedColumn<DateTime> get dataEmissao => $composableBuilder(
      column: $table.dataEmissao, builder: (column) => column);

  $$PacientesTableAnnotationComposer get pacienteId {
    final $$PacientesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.pacienteId,
        referencedTable: $db.pacientes,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PacientesTableAnnotationComposer(
              $db: $db,
              $table: $db.pacientes,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$AgendamentosTableAnnotationComposer get agendamentoId {
    final $$AgendamentosTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.agendamentoId,
        referencedTable: $db.agendamentos,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AgendamentosTableAnnotationComposer(
              $db: $db,
              $table: $db.agendamentos,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$NotasFiscaisTableTableManager extends RootTableManager<
    _$AppDatabase,
    $NotasFiscaisTable,
    NotasFiscai,
    $$NotasFiscaisTableFilterComposer,
    $$NotasFiscaisTableOrderingComposer,
    $$NotasFiscaisTableAnnotationComposer,
    $$NotasFiscaisTableCreateCompanionBuilder,
    $$NotasFiscaisTableUpdateCompanionBuilder,
    (NotasFiscai, $$NotasFiscaisTableReferences),
    NotasFiscai,
    PrefetchHooks Function({bool pacienteId, bool agendamentoId})> {
  $$NotasFiscaisTableTableManager(_$AppDatabase db, $NotasFiscaisTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$NotasFiscaisTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$NotasFiscaisTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$NotasFiscaisTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> pacienteId = const Value.absent(),
            Value<int?> agendamentoId = const Value.absent(),
            Value<double> valor = const Value.absent(),
            Value<bool> emitida = const Value.absent(),
            Value<DateTime?> dataEmissao = const Value.absent(),
          }) =>
              NotasFiscaisCompanion(
            id: id,
            pacienteId: pacienteId,
            agendamentoId: agendamentoId,
            valor: valor,
            emitida: emitida,
            dataEmissao: dataEmissao,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int pacienteId,
            Value<int?> agendamentoId = const Value.absent(),
            required double valor,
            Value<bool> emitida = const Value.absent(),
            Value<DateTime?> dataEmissao = const Value.absent(),
          }) =>
              NotasFiscaisCompanion.insert(
            id: id,
            pacienteId: pacienteId,
            agendamentoId: agendamentoId,
            valor: valor,
            emitida: emitida,
            dataEmissao: dataEmissao,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$NotasFiscaisTable, NotasFiscai>(table),
                    $$NotasFiscaisTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({pacienteId = false, agendamentoId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (pacienteId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.pacienteId,
                    referencedTable:
                        $$NotasFiscaisTableReferences._pacienteIdTable(db),
                    referencedColumn:
                        $$NotasFiscaisTableReferences._pacienteIdTable(db).id,
                  ) as T;
                }
                if (agendamentoId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.agendamentoId,
                    referencedTable:
                        $$NotasFiscaisTableReferences._agendamentoIdTable(db),
                    referencedColumn: $$NotasFiscaisTableReferences
                        ._agendamentoIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$NotasFiscaisTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $NotasFiscaisTable,
    NotasFiscai,
    $$NotasFiscaisTableFilterComposer,
    $$NotasFiscaisTableOrderingComposer,
    $$NotasFiscaisTableAnnotationComposer,
    $$NotasFiscaisTableCreateCompanionBuilder,
    $$NotasFiscaisTableUpdateCompanionBuilder,
    (NotasFiscai, $$NotasFiscaisTableReferences),
    NotasFiscai,
    PrefetchHooks Function({bool pacienteId, bool agendamentoId})>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$MedicosTableTableManager get medicos =>
      $$MedicosTableTableManager(_db, _db.medicos);
  $$ClinicasTableTableManager get clinicas =>
      $$ClinicasTableTableManager(_db, _db.clinicas);
  $$PacientesTableTableManager get pacientes =>
      $$PacientesTableTableManager(_db, _db.pacientes);
  $$AgendamentosTableTableManager get agendamentos =>
      $$AgendamentosTableTableManager(_db, _db.agendamentos);
  $$NotasFiscaisTableTableManager get notasFiscais =>
      $$NotasFiscaisTableTableManager(_db, _db.notasFiscais);
}
