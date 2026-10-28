import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pex/database/app_database.dart';
import 'package:pex/main.dart';
import 'package:pex/repositorios/agendamentos_repositorio.dart';
import 'package:pex/repositorios/medicos_repositorio.dart';
import 'package:pex/repositorios/pacientes_repositorio.dart';
import 'package:pex/shared/usuario/sessao.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'helpers/banco_teste.dart';

void main() {
  late AppDatabase bancoTeste;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    bancoTeste = criarBancoTeste();
  });

  Future<void> finalizar(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 1));
    await tester.runAsync(bancoTeste.close);
  }

  Future<void> aguardarBanco(WidgetTester tester) async {
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 50)),
    );
    await tester.pumpAndSettle();
  }

  Future<void> preencherLogin(
    WidgetTester tester, {
    required String usuario,
    required String senha,
  }) async {
    final campos = find.byType(TextFormField);
    await tester.enterText(campos.at(0), usuario);
    await tester.enterText(campos.at(1), senha);
    await tester.tap(find.text('Entrar'));
    await aguardarBanco(tester);
  }

  testWidgets('recusa login com senha incorreta', (tester) async {
    await tester.runAsync(() => cadastrarMedico(
          nome: 'Dr. Carlos',
          usuario: 'carlos',
          senha: '123456',
        ));

    await tester.pumpWidget(const MinhaAgendaApp());
    await preencherLogin(tester, usuario: 'carlos', senha: 'errada');

    expect(find.text('Usuário ou senha incorretos.'), findsOneWidget);
    expect(medicoLogado, isNull);
    await finalizar(tester);
  });

  testWidgets(
      'concluir consulta gera nota pendente, que some ao marcar como emitida',
      (tester) async {
    await tester.runAsync(() async {
      await entrarComoMedico();
      final paciente =
          await adicionarPaciente(novoPaciente(nome: 'Maria Silva'));
      final agora = DateTime.now();
      await adicionarAtendimento(novoAgendamento(
        pacienteId: paciente.id,
        dataHora: DateTime(agora.year, agora.month, agora.day, 23, 59),
        emitirNotaFiscal: true,
      ));
      encerrarSessao();
    });

    await tester.pumpWidget(const MinhaAgendaApp());
    await preencherLogin(tester, usuario: 'carlos', senha: '123456');

    expect(find.text('23:59 - Maria Silva'), findsOneWidget);
    expect(find.text('1 nota fiscal pendente'), findsNothing);

    await tester.tap(find.text('23:59 - Maria Silva'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Marcar como concluído'));
    await tester.pumpAndSettle();
    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.byType(BottomSheet, skipOffstage: false), findsOneWidget);
    await tester.tap(find.text('Sim, concluir'));
    await aguardarBanco(tester);

    await tester.tap(find.text('Fechar'));
    await tester.pumpAndSettle();
    expect(find.text('1 nota fiscal pendente'), findsOneWidget);

    await tester.tap(find.text('1 nota fiscal pendente'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Marcar como emitida'));
    await tester.pumpAndSettle();
    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.byType(BottomSheet, skipOffstage: false), findsOneWidget);
    await tester.tap(find.text('Sim, já foi emitida'));
    await aguardarBanco(tester);

    expect(
        find.text('Nenhuma nota fiscal pendente de emissão.'), findsOneWidget);
    await finalizar(tester);
  });
}
