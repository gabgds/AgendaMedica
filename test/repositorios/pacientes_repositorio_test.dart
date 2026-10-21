import 'package:flutter_test/flutter_test.dart';
import 'package:pex/database/app_database.dart';
import 'package:pex/repositorios/agendamentos_repositorio.dart';
import 'package:pex/repositorios/clinicas_repositorio.dart';
import 'package:pex/repositorios/pacientes_repositorio.dart';
import '../helpers/banco_teste.dart';

void main() {
  late AppDatabase bancoTeste;

  setUp(() async {
    bancoTeste = criarBancoTeste();
    await entrarComoMedico();
  });
  tearDown(() => bancoTeste.close());

  test('cadastra paciente com clínica e paciente avulso', () async {
    final clinica = await adicionarClinica(novaClinica(nome: 'Mente Sã'));
    final comClinica = await adicionarPaciente(
      novoPaciente(nome: 'Maria', clinicaId: clinica.id),
    );
    final avulso = await adicionarPaciente(
      novoPaciente(nome: 'João', cpf: '98765432100'),
    );

    expect(comClinica.nomeClinica, 'Mente Sã');
    expect(avulso.clinicaId, isNull);
    expect((await listarPacientes()).map((p) => p.nome), ['João', 'Maria']);
  });

  test('não permite CPF repetido para o mesmo médico', () async {
    await adicionarPaciente(novoPaciente(cpf: '11111111111'));

    expect(
      adicionarPaciente(novoPaciente(nome: 'Outro', cpf: '11111111111')),
      throwsA(isA<CpfJaCadastrado>()),
    );
  });

  test('médicos diferentes podem cadastrar o mesmo CPF', () async {
    await adicionarPaciente(novoPaciente(cpf: '11111111111'));
    await entrarComoMedico(nome: 'Dra. Ana', usuario: 'ana');

    await adicionarPaciente(novoPaciente(cpf: '11111111111'));
    expect(await listarPacientes(), hasLength(1));
  });

  test('edita mantendo o próprio CPF', () async {
    final paciente = await adicionarPaciente(novoPaciente());

    final editado = await atualizarPaciente(
      paciente.id,
      novoPaciente(nome: 'Maria Souza'),
    );
    expect(editado.nome, 'Maria Souza');
  });

  test('remove paciente junto com agendamentos e notas', () async {
    final paciente = await adicionarPaciente(novoPaciente());
    await adicionarAtendimento(
      novoAgendamento(pacienteId: paciente.id, emitirNotaFiscal: true),
    );

    await removerPaciente(paciente.id);

    expect(await listarPacientes(), isEmpty);
    expect(await bancoTeste.select(bancoTeste.agendamentos).get(), isEmpty);
    expect(await bancoTeste.select(bancoTeste.notasFiscais).get(), isEmpty);
  });

  test('não remove paciente com nota fiscal pendente', () async {
    final paciente = await adicionarPaciente(novoPaciente());
    final id = await adicionarAtendimento(
      novoAgendamento(pacienteId: paciente.id, emitirNotaFiscal: true),
    );
    await concluirAtendimento(id);

    expect(
      removerPaciente(paciente.id),
      throwsA(isA<PacienteComNotaPendente>()),
    );

    await marcarNotaFiscalEmitida(id);
    await removerPaciente(paciente.id);
    expect(await listarPacientes(), isEmpty);
  });
}
