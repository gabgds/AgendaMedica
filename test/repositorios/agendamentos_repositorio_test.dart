import 'package:flutter_test/flutter_test.dart';
import 'package:pex/database/app_database.dart';
import 'package:pex/paginas/pacientes/paciente.dart';
import 'package:pex/repositorios/agendamentos_repositorio.dart';
import 'package:pex/repositorios/clinicas_repositorio.dart';
import 'package:pex/repositorios/pacientes_repositorio.dart';
import '../helpers/banco_teste.dart';

void main() {
  late AppDatabase bancoTeste;
  late Paciente paciente;
  final dia = DateTime(2026, 8, 27);

  setUp(() async {
    bancoTeste = criarBancoTeste();
    await entrarComoMedico();
    paciente = await adicionarPaciente(novoPaciente());
  });
  tearDown(() => bancoTeste.close());

  Future<int> agendar({
    int hora = 14,
    DateTime? data,
    bool nota = false,
    int? clinicaId,
    String sala = '',
  }) {
    final base = data ?? dia;
    return adicionarAtendimento(novoAgendamento(
      pacienteId: paciente.id,
      dataHora: DateTime(base.year, base.month, base.day, hora),
      emitirNotaFiscal: nota,
      clinicaId: clinicaId,
      sala: sala,
    ));
  }

  Future<List<int>> idsDoDia(DateTime data) async =>
      (await observarAtendimentosDoDia(data).first).map((a) => a.id).toList();

  group('agenda do dia', () {
    test('o mesmo paciente pode ter consultas em clínicas diferentes',
        () async {
      final centro = await adicionarClinica(novaClinica(nome: 'Centro'));
      final norte = await adicionarClinica(novaClinica(nome: 'Norte'));
      final primeira = await agendar(hora: 9, clinicaId: centro.id);
      final segunda = await agendar(hora: 15, clinicaId: norte.id);

      final consultaCentro = (await buscarAtendimento(primeira))!;
      final consultaNorte = (await buscarAtendimento(segunda))!;
      expect(consultaCentro.pacienteId, paciente.id);
      expect(consultaNorte.pacienteId, paciente.id);
      expect(consultaCentro.clinicaId, centro.id);
      expect(consultaNorte.clinicaId, norte.id);
      expect(await listarPacientes(), hasLength(1));
    });

    test('lista só o dia pedido, em ordem de horário', () async {
      final tarde = await agendar(hora: 16);
      final manha = await agendar(hora: 8);
      await agendar(data: DateTime(2026, 8, 28));

      expect(await idsDoDia(dia), [manha, tarde]);
    });

    test('inclui consultas às 23h e exclui as do dia seguinte à 0h', () async {
      final noite = await agendar(hora: 23);
      await agendar(data: DateTime(2026, 8, 28), hora: 0);

      expect(await idsDoDia(dia), [noite]);
    });

    test('não mostra agendamentos cancelados', () async {
      final id = await agendar();
      await cancelarAtendimento(id);

      expect(await idsDoDia(dia), isEmpty);
    });

    test('preenche nome do paciente, clínica e sala', () async {
      final clinica = await adicionarClinica(novaClinica(nome: 'Mente Sã'));
      final id = await agendar(clinicaId: clinica.id, sala: '3');

      final atendimento = (await buscarAtendimento(id))!;
      expect(atendimento.nomePaciente, 'Maria Silva');
      expect(atendimento.local, 'Mente Sã - Sala 3');
      expect(atendimento.status, StatusAgendamento.agendado);
    });

    test('consulta avulsa não guarda sala', () async {
      final id = await agendar(sala: '3');

      final atendimento = (await buscarAtendimento(id))!;
      expect(atendimento.sala, isEmpty);
      expect(atendimento.local, 'Avulso');
    });

    test('o stream avisa a tela quando um agendamento é criado', () async {
      final emissoes = observarAtendimentosDoDia(dia)
          .map((lista) => lista.length)
          .take(2)
          .toList();
      await Future<void>.delayed(Duration.zero);
      await agendar();

      expect(await emissoes, [0, 1]);
    });

    test('não agenda paciente de outro médico', () async {
      await entrarComoMedico(nome: 'Dra. Ana', usuario: 'ana');

      expect(agendar(), throwsArgumentError);
    });
  });

  group('nota fiscal', () {
    test('fica pendente só depois de concluir o atendimento', () async {
      final id = await agendar(nota: true);
      Future<int> pendentes() async =>
          (await observarNotasFiscais(apenasPendentes: true).first).length;

      expect(await pendentes(), 0);
      expect((await buscarAtendimento(id))!.situacaoNotaFiscal,
          'Aguardando conclusão do atendimento');

      expect(await concluirAtendimento(id), isTrue);
      expect(await pendentes(), 1);
      expect((await buscarAtendimento(id))!.notaFiscalPendente, isTrue);
    });

    test('sai das pendências ao marcar como emitida', () async {
      final id = await agendar(nota: true);
      await concluirAtendimento(id);

      expect(await marcarNotaFiscalEmitida(id), isTrue);

      expect(await observarNotasFiscais(apenasPendentes: true).first, isEmpty);
      final nota = await bancoTeste.select(bancoTeste.notasFiscais).getSingle();
      expect(nota.emitida, isTrue);
      expect(nota.dataEmissao, isNotNull);
      expect(
        await observarNotasFiscais(pacienteId: paciente.id).first,
        hasLength(1),
      );
    });

    test('atendimento sem nota não gera pendência', () async {
      final id = await agendar();
      await concluirAtendimento(id);

      expect(await observarNotasFiscais(apenasPendentes: true).first, isEmpty);
      expect(await marcarNotaFiscalEmitida(id), isFalse);
    });

    test('não marca como emitida antes de concluir', () async {
      final id = await agendar(nota: true);

      expect(await marcarNotaFiscalEmitida(id), isFalse);
    });

    test('pendência continua visível nos dias seguintes', () async {
      final id = await agendar(nota: true, data: DateTime(2026, 1, 10));
      await concluirAtendimento(id);

      expect(await idsDoDia(dia), isEmpty);
      expect(await observarNotasFiscais(apenasPendentes: true).first,
          hasLength(1));
    });
  });

  group('alterações de status', () {
    test('não conclui nem cancela duas vezes', () async {
      final id = await agendar();

      expect(await concluirAtendimento(id), isTrue);
      expect(await concluirAtendimento(id), isFalse);
      expect(await cancelarAtendimento(id), isFalse);
    });

    test('edita horário e liga ou desliga a nota fiscal', () async {
      final id = await agendar();

      final editado = await atualizarAtendimento(
        id,
        novoAgendamento(
          pacienteId: paciente.id,
          dataHora: DateTime(2026, 8, 27, 9, 30),
          emitirNotaFiscal: true,
        ),
      );
      expect(editado, isTrue);
      var atendimento = (await buscarAtendimento(id))!;
      expect(atendimento.horario, '09:30');
      expect(atendimento.emitirNotaFiscal, isTrue);

      await atualizarAtendimento(
        id,
        novoAgendamento(pacienteId: paciente.id, emitirNotaFiscal: false),
      );
      atendimento = (await buscarAtendimento(id))!;
      expect(atendimento.emitirNotaFiscal, isFalse);
      expect(await bancoTeste.select(bancoTeste.notasFiscais).get(), isEmpty);
    });

    test('não edita atendimento concluído', () async {
      final id = await agendar();
      await concluirAtendimento(id);

      final editado = await atualizarAtendimento(
        id,
        novoAgendamento(
            pacienteId: paciente.id, dataHora: DateTime(2026, 9, 1)),
      );
      expect(editado, isFalse);
    });

    test('nota de atendimento cancelado não aparece nas listas', () async {
      final id = await agendar(nota: true);
      await cancelarAtendimento(id);

      expect(
          await observarNotasFiscais(pacienteId: paciente.id).first, isEmpty);
    });
  });
}
