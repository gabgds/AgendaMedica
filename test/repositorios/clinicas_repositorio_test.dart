import 'package:flutter_test/flutter_test.dart';
import 'package:pex/database/app_database.dart';
import 'package:pex/paginas/clinicas/formulario_clinica/nova_clinica.dart';
import 'package:pex/repositorios/agendamentos_repositorio.dart';
import 'package:pex/repositorios/clinicas_repositorio.dart';
import 'package:pex/repositorios/pacientes_repositorio.dart';
import 'package:pex/shared/usuario/sessao.dart';

import '../helpers/banco_teste.dart';

void main() {
  late AppDatabase bancoTeste;

  setUp(() async {
    bancoTeste = criarBancoTeste();
    await entrarComoMedico();
  });
  tearDown(() => bancoTeste.close());

  test('cadastra, lista em ordem alfabética e edita', () async {
    await adicionarClinica(novaClinica(nome: 'Multicare'));
    final mente = await adicionarClinica(novaClinica(nome: 'Mente Sã'));

    expect((await listarClinicas()).map((c) => c.nome), [
      'Mente Sã',
      'Multicare',
    ]);

    await atualizarClinica(
      mente.id,
      const NovaClinica(nome: 'Mente Sã II', endereco: 'Outro endereço'),
    );
    final clinicas = await listarClinicas();
    expect(clinicas.first.nome, 'Mente Sã II');
    expect(clinicas.first.endereco, 'Outro endereço');
  });

  test('cada médico vê apenas as próprias clínicas', () async {
    await adicionarClinica(novaClinica(nome: 'Do Carlos'));
    await entrarComoMedico(nome: 'Dra. Ana', usuario: 'ana');
    await adicionarClinica(novaClinica(nome: 'Da Ana'));

    expect((await listarClinicas()).map((c) => c.nome), ['Da Ana']);
  });

  test('remover clínica não altera o cadastro dos pacientes', () async {
    final clinica = await adicionarClinica(novaClinica());
    final paciente = await adicionarPaciente(
      novoPaciente(),
    );

    await removerClinica(clinica.id);

    expect(await listarClinicas(), isEmpty);
    expect(await buscarPaciente(paciente.id), isNotNull);
  });

  test('não remove clínica com agendamentos', () async {
    final clinica = await adicionarClinica(novaClinica());
    final paciente = await adicionarPaciente(novoPaciente());
    await adicionarAtendimento(
      novoAgendamento(pacienteId: paciente.id, clinicaId: clinica.id),
    );

    await expectLater(
      removerClinica(clinica.id),
      throwsA(isA<ClinicaComAgendamentos>()),
    );
    expect(await listarClinicas(), hasLength(1));
  });

  test(
    'remove clínica após cancelar sem precisar remover o paciente',
    () async {
      final clinica = await adicionarClinica(novaClinica());
      final paciente = await adicionarPaciente(
        novoPaciente(),
      );
      final id = await adicionarAtendimento(
        novoAgendamento(
          pacienteId: paciente.id,
          clinicaId: clinica.id,
          emitirNotaFiscal: true,
        ),
      );
      await cancelarAtendimento(id);

      await removerClinica(clinica.id);

      expect(await listarClinicas(), isEmpty);
      expect(await buscarPaciente(paciente.id), isNotNull);
      final atendimento = (await buscarAtendimento(id))!;
      expect(atendimento.status, StatusAgendamento.cancelado);
      expect(atendimento.clinicaId, isNull);
      expect(
        await bancoTeste.select(bancoTeste.notasFiscais).get(),
        hasLength(1),
      );
      expect(
        await bancoTeste.customSelect('PRAGMA foreign_key_check').get(),
        isEmpty,
      );
    },
  );

  test('um cancelado não libera a clínica se ainda há outro ativo', () async {
    final clinica = await adicionarClinica(novaClinica());
    final paciente = await adicionarPaciente(
      novoPaciente(),
    );
    final cancelado = await adicionarAtendimento(
      novoAgendamento(pacienteId: paciente.id, clinicaId: clinica.id),
    );
    await cancelarAtendimento(cancelado);
    final ativo = await adicionarAtendimento(
      novoAgendamento(pacienteId: paciente.id, clinicaId: clinica.id),
    );

    await expectLater(
      removerClinica(clinica.id),
      throwsA(isA<ClinicaComAgendamentos>()),
    );

    expect(await buscarPaciente(paciente.id), isNotNull);
    expect((await buscarAtendimento(cancelado))!.clinicaId, clinica.id);
    expect((await buscarAtendimento(ativo))!.clinicaId, clinica.id);
  });

  test(
    'atendimentos concluídos continuam protegendo o histórico da clínica',
    () async {
      final clinica = await adicionarClinica(novaClinica());
      final paciente = await adicionarPaciente(novoPaciente());
      final id = await adicionarAtendimento(
        novoAgendamento(pacienteId: paciente.id, clinicaId: clinica.id),
      );
      await concluirAtendimento(id);

      await expectLater(
        removerClinica(clinica.id),
        throwsA(isA<ClinicaComAgendamentos>()),
      );
      expect((await buscarAtendimento(id))!.clinicaId, clinica.id);
    },
  );

  test('não altera vínculos de clínica de outro médico', () async {
    final clinica = await adicionarClinica(novaClinica());
    final paciente = await adicionarPaciente(
      novoPaciente(),
    );
    final id = await adicionarAtendimento(
      novoAgendamento(pacienteId: paciente.id, clinicaId: clinica.id),
    );
    await cancelarAtendimento(id);
    await entrarComoMedico(nome: 'Dra. Ana', usuario: 'ana');

    await removerClinica(clinica.id);

    expect(await bancoTeste.select(bancoTeste.clinicas).get(), hasLength(1));
    final pacientes = await bancoTeste.select(bancoTeste.pacientes).get();
    final agendamentos = await bancoTeste.select(bancoTeste.agendamentos).get();
    expect(pacientes.single.id, paciente.id);
    expect(agendamentos.single.clinicaId, clinica.id);
  });

  test('as consultas exigem um médico logado', () async {
    encerrarSessao();
    expect(() => listarClinicas(), throwsStateError);
  });
}
