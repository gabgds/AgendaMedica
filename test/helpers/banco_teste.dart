import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:pex/database/app_database.dart';
import 'package:pex/database/banco.dart';
import 'package:pex/paginas/agenda/formulario_agenda/novo_agendamento.dart';
import 'package:pex/paginas/clinicas/formulario_clinica/nova_clinica.dart';
import 'package:pex/paginas/pacientes/formulario_paciente/novo_paciente.dart';
import 'package:pex/repositorios/medicos_repositorio.dart';
import 'package:pex/shared/usuario/perfil_usuario.dart';
import 'package:pex/shared/usuario/sessao.dart';

AppDatabase criarBancoTeste() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  final bancoTeste = AppDatabase.paraTeste(NativeDatabase.memory());
  definirBanco(bancoTeste);
  encerrarSessao();
  return bancoTeste;
}

Future<PerfilUsuario> entrarComoMedico({
  String nome = 'Dr. Carlos',
  String usuario = 'carlos',
}) async {
  final medico =
      await cadastrarMedico(nome: nome, usuario: usuario, senha: '123456');
  iniciarSessao(medico);
  return medico;
}

NovoPaciente novoPaciente({
  String nome = 'Maria Silva',
  String cpf = '12345678901',
}) {
  return NovoPaciente(
    nome: nome,
    dataNascimento: DateTime(1990, 5, 20),
    cpf: cpf,
    endereco: 'Rua das Flores, 123',
    email: 'maria@exemplo.com',
    telefone: '47999998888',
  );
}

NovaClinica novaClinica({String nome = 'Clínica Mente Sã'}) {
  return NovaClinica(nome: nome, endereco: 'Rua dos Pinheiros, 45');
}

NovoAgendamento novoAgendamento({
  required int pacienteId,
  int? clinicaId,
  DateTime? dataHora,
  bool emitirNotaFiscal = false,
  String sala = '',
}) {
  return NovoAgendamento(
    pacienteId: pacienteId,
    clinicaId: clinicaId,
    dataHora: dataHora ?? DateTime(2026, 8, 27, 14),
    duracaoMinutos: 60,
    emitirNotaFiscal: emitirNotaFiscal,
    sala: sala,
  );
}
