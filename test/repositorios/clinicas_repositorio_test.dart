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

    expect((await listarClinicas()).map((c) => c.nome), ['Mente Sã', 'Multicare']);

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

  test('ao remover, os pacientes da clínica passam a ser avulsos', () async {
    final clinica = await adicionarClinica(novaClinica());
    final paciente = await adicionarPaciente(novoPaciente(clinicaId: clinica.id));

    await removerClinica(clinica.id);

    expect(await listarClinicas(), isEmpty);
    expect((await buscarPaciente(paciente.id))!.clinicaId, isNull);
  });

  test('não remove clínica com agendamentos', () async {
    final clinica = await adicionarClinica(novaClinica());
    final paciente = await adicionarPaciente(novoPaciente());
    await adicionarAtendimento(
      novoAgendamento(pacienteId: paciente.id, clinicaId: clinica.id),
    );

    expect(removerClinica(clinica.id), throwsA(isA<ClinicaComAgendamentos>()));
    expect(await listarClinicas(), hasLength(1));
  });

  test('as consultas exigem um médico logado', () async {
    encerrarSessao();
    expect(() => listarClinicas(), throwsStateError);
  });
}
