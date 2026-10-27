import 'package:pex/shared/avisos/aviso.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pex/database/app_database.dart';
import 'package:pex/main.dart';
import 'package:pex/paginas/clinicas/clinica.dart';
import 'package:pex/paginas/login.dart';
import 'package:pex/paginas/pacientes/paciente.dart';
import 'package:pex/repositorios/agendamentos_repositorio.dart';
import 'package:pex/repositorios/clinicas_repositorio.dart';
import 'package:pex/repositorios/medicos_repositorio.dart';
import 'package:pex/repositorios/pacientes_repositorio.dart';
import 'package:pex/shared/formulario/modal_formulario.dart';
import 'package:pex/shared/usuario/sessao.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'helpers/banco_teste.dart';

void main() {
  late AppDatabase bancoTeste;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    bancoTeste = criarBancoTeste();
  });

  Future<void> aguardarBanco(WidgetTester tester) async {
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 50)),
    );
    await tester.pumpAndSettle();
  }

  Future<void> abrirApp(WidgetTester tester) async {
    tester.view.physicalSize = const Size(430, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const MinhaAgendaApp());
    await aguardarBanco(tester);
  }

  Future<void> abrirPagina(WidgetTester tester, String nome) async {
    await tester.tap(find.text(nome));
    await aguardarBanco(tester);
  }

  void testarInterface(
    String descricao,
    Future<void> Function(WidgetTester) teste,
  ) {
    testWidgets(descricao, (tester) async {
      try {
        await teste(tester);
      } finally {
        await tester.pumpWidget(const SizedBox());
        await tester.pump(const Duration(seconds: 1));
        await tester.runAsync(bancoTeste.close);
      }
    });
  }

  testarInterface('aviso permanece acima de modais empilhados e de diálogo', (
    tester,
  ) async {
    await tester.runAsync(entrarComoMedico);
    await abrirApp(tester);
    final context = tester.element(find.byType(Navigator));
    abrirModalFormulario<void>(
      context,
      builder: (context) => ModalFormulario(
        titulo: 'Primeiro modal',
        conteudo: TextButton(
          onPressed: () => abrirModalFormulario<void>(
            context,
            builder: (context) => ModalFormulario(
              titulo: 'Segundo modal',
              conteudo: TextButton(
                onPressed: () {
                  mostrarAviso(context, 'Aviso sobre os modais');
                  showDialog<void>(
                    context: context,
                    builder: (context) =>
                        const AlertDialog(title: Text('Diálogo aberto')),
                  );
                },
                child: const Text('Exibir aviso e diálogo'),
              ),
            ),
          ),
          child: const Text('Abrir segundo modal'),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Abrir segundo modal'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Exibir aviso e diálogo'));
    await tester.pumpAndSettle();

    expect(find.text('Diálogo aberto'), findsOneWidget);
    expect(find.text('Aviso sobre os modais').hitTestable(), findsOneWidget);
    expect(tester.getTopLeft(find.text('Aviso sobre os modais')).dy,
        lessThan(150));
  });

  testarInterface('aviso de login aparece acima do teclado', (tester) async {
    await abrirApp(tester);
    tester.view.viewInsets = const FakeViewPadding(bottom: 300);
    addTearDown(tester.view.resetViewInsets);
    await tester.pump();
    final context = tester.element(find.byType(Login));
    mostrarAviso(context, 'Aviso com teclado');
    await tester.pumpAndSettle();

    final aviso = find.text('Aviso com teclado');
    expect(aviso.hitTestable(), findsOneWidget);
    expect(tester.getTopLeft(aviso).dy, lessThan(150));
  });

  testarInterface('avisos substituem o anterior, podem ser fechados e expiram',
      (tester) async {
    await abrirApp(tester);
    final context = tester.element(find.byType(Login));
    mostrarAviso(context, 'Primeiro aviso');
    await tester.pump(const Duration(seconds: 3));
    mostrarAviso(context, 'Segundo aviso');
    await tester.pump(const Duration(seconds: 2));
    expect(find.text('Primeiro aviso'), findsNothing);
    expect(find.text('Segundo aviso').hitTestable(), findsOneWidget);
    await tester.tap(find.byIcon(Icons.close));
    await tester.pump();
    expect(find.text('Segundo aviso'), findsNothing);

    mostrarAviso(context, 'Aviso temporário');
    await tester.pump();
    expect(find.text('Aviso temporário'), findsOneWidget);
    await tester.pump(const Duration(seconds: 5));
    expect(find.text('Aviso temporário'), findsNothing);
  });

  testarInterface('cadastro, edição e perfil do paciente não exibem clínica',
      (tester) async {
    late Paciente paciente;
    await tester.runAsync(() async {
      await entrarComoMedico();
      await adicionarClinica(novaClinica());
      paciente = await adicionarPaciente(novoPaciente());
    });
    await abrirApp(tester);
    await abrirPagina(tester, 'Pacientes');
    await tester.tap(find.text('+ Novo'));
    await tester.pumpAndSettle();
    expect(find.text('Novo paciente'), findsOneWidget);
    expect(find.text('CLÍNICA'), findsNothing);
    expect(find.byType(DropdownButtonFormField<int>), findsNothing);
    await tester.tap(find.byTooltip('Voltar'));
    await tester.pumpAndSettle();

    await tester.tap(find.text(paciente.nome));
    await aguardarBanco(tester);
    expect(find.text('CLÍNICA'), findsNothing);
    await tester.tap(find.text('Editar paciente'));
    await tester.pumpAndSettle();
    expect(find.text('CLÍNICA'), findsNothing);
    expect(find.byType(DropdownButtonFormField<int>), findsNothing);
  });

  testarInterface('cancelar confirmação mantém paciente e agendamento', (
    tester,
  ) async {
    late Paciente paciente;
    late int id;
    await tester.runAsync(() async {
      await entrarComoMedico();
      paciente = await adicionarPaciente(novoPaciente());
      id = await adicionarAtendimento(novoAgendamento(pacienteId: paciente.id));
    });
    await abrirApp(tester);
    await abrirPagina(tester, 'Pacientes');
    await tester.tap(find.text(paciente.nome));
    await aguardarBanco(tester);
    await tester.tap(find.text('Remover paciente'));
    await tester.pumpAndSettle();
    expect(find.text('Remover paciente?'), findsOneWidget);

    await tester.tap(find.text('Cancelar'));
    await tester.pumpAndSettle();

    expect(await tester.runAsync(() => buscarPaciente(paciente.id)), isNotNull);
    expect(await tester.runAsync(() => buscarAtendimento(id)), isNotNull);
  });

  testarInterface(
    'exclusão de paciente com consulta ativa exibe aviso sobre o perfil',
    (tester) async {
      late Paciente paciente;
      late int id;
      await tester.runAsync(() async {
        await entrarComoMedico();
        paciente = await adicionarPaciente(novoPaciente());
        id = await adicionarAtendimento(
          novoAgendamento(pacienteId: paciente.id),
        );
      });
      await abrirApp(tester);
      await abrirPagina(tester, 'Pacientes');
      await tester.tap(find.text(paciente.nome));
      await aguardarBanco(tester);
      await tester.tap(find.text('Remover paciente'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Remover'));
      await aguardarBanco(tester);

      expect(
        find.text(const PacienteComAgendamentos().toString()).hitTestable(),
        findsOneWidget,
      );
      expect(find.text('Remover paciente'), findsOneWidget);
      expect(
        await tester.runAsync(() => buscarPaciente(paciente.id)),
        isNotNull,
      );
      expect(await tester.runAsync(() => buscarAtendimento(id)), isNotNull);
    },
  );

  testarInterface('clínica com consulta ativa mostra aviso e mantém vínculos', (
    tester,
  ) async {
    late Clinica clinica;
    late Paciente paciente;
    await tester.runAsync(() async {
      await entrarComoMedico();
      clinica = await adicionarClinica(novaClinica());
      paciente = await adicionarPaciente(novoPaciente());
      await adicionarAtendimento(
        novoAgendamento(pacienteId: paciente.id, clinicaId: clinica.id),
      );
    });
    await abrirApp(tester);
    await abrirPagina(tester, 'Clínicas');
    await tester.tap(find.text(clinica.nome));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Remover clínica'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Remover'));
    await aguardarBanco(tester);

    expect(
      find.text(const ClinicaComAgendamentos().toString()).hitTestable(),
      findsOneWidget,
    );
    final mantido = await tester.runAsync(() => buscarPaciente(paciente.id));
    expect(mantido!.id, paciente.id);
  });

  testarInterface('clínica com consulta cancelada só é removida ao confirmar', (
    tester,
  ) async {
    late Clinica clinica;
    late Paciente paciente;
    await tester.runAsync(() async {
      await entrarComoMedico();
      clinica = await adicionarClinica(novaClinica());
      paciente = await adicionarPaciente(novoPaciente());
      final id = await adicionarAtendimento(
        novoAgendamento(pacienteId: paciente.id, clinicaId: clinica.id),
      );
      await cancelarAtendimento(id);
    });
    await abrirApp(tester);
    await abrirPagina(tester, 'Clínicas');
    await tester.tap(find.text(clinica.nome));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Remover clínica'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cancelar'));
    await tester.pumpAndSettle();
    expect(await tester.runAsync(listarClinicas), hasLength(1));

    await tester.tap(find.text('Remover clínica'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Remover'));
    await aguardarBanco(tester);

    expect(find.text('Remover clínica'), findsNothing);
    expect(await tester.runAsync(listarClinicas), isEmpty);
    final mantido = await tester.runAsync(() => buscarPaciente(paciente.id));
    expect(mantido, isNotNull);
  });

  testarInterface('perfil só grava após confirmar e permite continuar editando',
      (
    tester,
  ) async {
    await tester.runAsync(entrarComoMedico);
    final id = medicoLogadoId;
    await abrirApp(tester);
    await abrirPagina(tester, 'Opções');
    await tester.tap(find.text('Editar dados pessoais'));
    await tester.pumpAndSettle();
    final campos = find.byType(TextFormField);
    await tester.enterText(campos.at(0), 'Dr. Carlos Silva');
    await tester.enterText(campos.at(1), 'carlos.silva');
    await tester.enterText(campos.at(2), 'nova123456');
    await tester.enterText(campos.at(3), 'nova123456');
    await tester.tap(find.widgetWithText(FilledButton, 'Editar perfil'));
    await tester.pumpAndSettle();
    expect(find.text('Salvar alterações do perfil?'), findsOneWidget);
    expect((await tester.runAsync(() => buscarMedico(id)))!.usuario, 'carlos');

    await tester.tap(find.text('Continuar editando'));
    await tester.pumpAndSettle();
    expect(find.text('Dr. Carlos Silva'), findsOneWidget);
    expect((await tester.runAsync(() => buscarMedico(id)))!.usuario, 'carlos');

    await tester.tap(find.widgetWithText(FilledButton, 'Editar perfil'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Sim, salvar'));
    await aguardarBanco(tester);

    expect(find.text('Perfil atualizado.').hitTestable(), findsOneWidget);
    expect(
      (await tester.runAsync(() => buscarMedico(id)))!.nome,
      'Dr. Carlos Silva',
    );
    expect(medicoLogado!.usuario, 'carlos.silva');
    expect(
      await tester.runAsync(
        () => autenticarMedico(usuario: 'carlos.silva', senha: 'nova123456'),
      ),
      isNotNull,
    );
  });
}
