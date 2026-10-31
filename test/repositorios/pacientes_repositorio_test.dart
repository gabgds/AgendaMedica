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

  test('cadastra pacientes independentemente de clínicas', () async {
    await adicionarClinica(novaClinica(nome: 'Mente Sã'));
    await adicionarPaciente(novoPaciente(nome: 'Maria'));
    await adicionarPaciente(novoPaciente(nome: 'João', cpf: '98765432100'));

    expect((await listarPacientes()).map((p) => p.nome), ['João', 'Maria']);
    final colunas =
        await bancoTeste.customSelect('PRAGMA table_info(pacientes)').get();
    expect(colunas.map((c) => c.read<String>('name')),
        isNot(contains('clinica_id')));
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

  test('não remove paciente nem seus agendamentos ativos e notas', () async {
    final paciente = await adicionarPaciente(novoPaciente());
    final id = await adicionarAtendimento(
      novoAgendamento(pacienteId: paciente.id, emitirNotaFiscal: true),
    );

    await expectLater(
      removerPaciente(paciente.id),
      throwsA(isA<PacienteComAgendamentos>()),
    );

    expect(await buscarPaciente(paciente.id), isNotNull);
    expect((await buscarAtendimento(id))!.status, StatusAgendamento.agendado);
    expect(
      await bancoTeste.select(bancoTeste.notasFiscais).get(),
      hasLength(1),
    );
  });

  test('remove paciente junto com agendamentos cancelados e notas', () async {
    final paciente = await adicionarPaciente(novoPaciente());
    final id = await adicionarAtendimento(
      novoAgendamento(pacienteId: paciente.id, emitirNotaFiscal: true),
    );
    await cancelarAtendimento(id);

    await removerPaciente(paciente.id);

    expect(await listarPacientes(), isEmpty);
    expect(await bancoTeste.select(bancoTeste.agendamentos).get(), isEmpty);
    expect(await bancoTeste.select(bancoTeste.notasFiscais).get(), isEmpty);
    expect(
      await bancoTeste.customSelect('PRAGMA foreign_key_check').get(),
      isEmpty,
    );
  });

  test(
    'um cancelado não permite excluir paciente que ainda tem outro ativo',
    () async {
      final paciente = await adicionarPaciente(novoPaciente());
      final cancelado = await adicionarAtendimento(
        novoAgendamento(pacienteId: paciente.id),
      );
      await cancelarAtendimento(cancelado);
      final ativo = await adicionarAtendimento(
        novoAgendamento(pacienteId: paciente.id),
      );

      await expectLater(
        removerPaciente(paciente.id),
        throwsA(isA<PacienteComAgendamentos>()),
      );
      expect(await buscarAtendimento(cancelado), isNotNull);
      expect(await buscarAtendimento(ativo), isNotNull);
    },
  );

  test('não remove paciente com nota fiscal pendente', () async {
    final paciente = await adicionarPaciente(novoPaciente());
    final id = await adicionarAtendimento(
      novoAgendamento(pacienteId: paciente.id, emitirNotaFiscal: true),
    );
    await concluirAtendimento(id);

    await expectLater(
      removerPaciente(paciente.id),
      throwsA(isA<PacienteComNotaPendente>()),
    );

    await marcarNotaFiscalEmitida(id);
    await removerPaciente(paciente.id);
    expect(await listarPacientes(), isEmpty);
  });

  test('não apaga paciente, agendamentos ou notas de outro médico', () async {
    final paciente = await adicionarPaciente(novoPaciente());
    final id = await adicionarAtendimento(
      novoAgendamento(pacienteId: paciente.id, emitirNotaFiscal: true),
    );
    await cancelarAtendimento(id);
    await entrarComoMedico(nome: 'Dra. Ana', usuario: 'ana');

    await removerPaciente(paciente.id);

    expect(await bancoTeste.select(bancoTeste.pacientes).get(), hasLength(1));
    expect(
      await bancoTeste.select(bancoTeste.agendamentos).get(),
      hasLength(1),
    );
    expect(
      await bancoTeste.select(bancoTeste.notasFiscais).get(),
      hasLength(1),
    );
  });
}
