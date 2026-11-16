import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pex/shared/formulario/modal_formulario.dart';
import 'package:pex/shared/formulario/seletores_modal.dart';

void main() {
  void caso(String nome, Future<void> Function(WidgetTester) executar) {
    testWidgets(nome, (tester) async {
      try {
        await executar(tester);
      } finally {
        await tester.pumpWidget(const SizedBox());
        await tester.pumpAndSettle();
      }
    });
  }

  Future<void> abrir(
    WidgetTester tester, {
    Size tamanho = const Size(393, 852),
    ValueChanged<String?>? aoFechar,
    ValueChanged<String?>? aoReceber,
  }) async {
    tester.view.physicalSize = tamanho;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: Builder(
          builder: (context) => TextButton(
            onPressed: () async {
              final resultado = await abrirModalFormulario<String>(
                context,
                builder: (context) => _FormularioDeTeste(aoReceber: aoReceber),
              );
              aoFechar?.call(resultado);
            },
            child: const Text('Abrir painel'),
          ),
        ),
      ),
    ));
    await tester.tap(find.text('Abrir painel'));
    await tester.pumpAndSettle();
  }

  void painelUnico() {
    expect(find.byType(BottomSheet, skipOffstage: false), findsOneWidget);
    expect(find.byType(AlertDialog, skipOffstage: false), findsNothing);
  }

  caso('troca o conteúdo no mesmo painel e conserva o formulário e resultados',
      (tester) async {
    String? resultadoFinal;
    await abrir(tester, aoFechar: (valor) => resultadoFinal = valor);
    await tester.enterText(find.byType(TextField), 'Rascunho preservado');
    await tester.tap(find.text('Próxima etapa'));
    await tester.pumpAndSettle();
    painelUnico();
    expect(find.text('Formulário'), findsNothing);
    expect(find.text('Escolha'), findsOneWidget);

    await tester.tap(find.text('Usar resultado'));
    await tester.pumpAndSettle();
    painelUnico();
    expect(find.text('Rascunho preservado'), findsOneWidget);
    expect(find.text('Recebido: Escolhido'), findsOneWidget);
    await tester.tap(find.text('Salvar formulário'));
    await tester.pumpAndSettle();
    expect(find.byType(BottomSheet), findsNothing);
    expect(resultadoFinal, 'Rascunho preservado');
  });

  caso('Voltar do Android retorna uma etapa antes de fechar o painel',
      (tester) async {
    await abrir(tester);
    await tester.enterText(find.byType(TextField), 'Não perder');
    await tester.tap(find.text('Próxima etapa'));
    await tester.pumpAndSettle();

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    painelUnico();
    expect(find.text('Não perder'), findsOneWidget);
    expect(find.text('Escolha'), findsNothing);

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(find.byType(BottomSheet), findsNothing);
  });

  caso('fechar o painel encerra o fluxo e libera os resultados pendentes',
      (tester) async {
    final recebidos = <String?>[];
    var encerrado = false;
    await abrir(tester,
        aoReceber: recebidos.add, aoFechar: (_) => encerrado = true);
    await tester.tap(find.text('Próxima etapa'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Fechar painel'));
    await tester.pumpAndSettle();
    expect(find.byType(BottomSheet), findsNothing);
    expect(encerrado, isTrue);
    expect(recebidos, [null]);
    expect(find.text('Abrir painel'), findsOneWidget);
  });

  caso('data e horário são escolhidos no painel sem perder o rascunho',
      (tester) async {
    await abrir(tester);
    await tester.enterText(find.byType(TextField), 'Consulta de revisão');
    await tester.tap(find.text('Escolher data'));
    await tester.pumpAndSettle();
    painelUnico();
    expect(find.byType(CalendarDatePicker), findsOneWidget);
    await tester.tap(find.text('29').hitTestable());
    await tester.tap(find.text('Selecionar'));
    await tester.pumpAndSettle();
    expect(find.text('Data: 29/10/2026'), findsOneWidget);
    expect(find.text('Consulta de revisão'), findsOneWidget);

    await tester.tap(find.text('Escolher horário'));
    await tester.pumpAndSettle();
    painelUnico();
    // O seletor atual usa o relógio circular do Material em formato 24 horas.
    final seletorHorario = find.byType(TimePickerDialog);
    expect(seletorHorario, findsOneWidget);
    expect(
      tester.widget<TimePickerDialog>(seletorHorario).initialEntryMode,
      TimePickerEntryMode.dial,
    );

    // Seleciona 10:15 diretamente no mostrador circular de 24 horas.
    // Evita alternar para a entrada por texto, que pode gerar overflow
    // de layout em testes de widget com o espaço disponível do diálogo.
    // A partir do Flutter 3.35, o TimePicker deixou de expor a chave
    // 'time-picker-dial'. Localizamos o mostrador pelo widget interno _Dial
    // e pegamos seu CustomPaint, que corresponde à área clicável do relógio.
    final dial = find.descendant(
      of: seletorHorario,
      matching: find.byWidgetPredicate(
        (widget) => widget.runtimeType.toString() == '_Dial',
      ),
    );
    expect(dial, findsOneWidget);

    final mostrador = find.descendant(
      of: dial,
      matching: find.byType(CustomPaint),
    );
    expect(mostrador, findsOneWidget);

    final retanguloMostrador = tester.getRect(mostrador);
    final centroMostrador = retanguloMostrador.center;
    final raio = retanguloMostrador.shortestSide / 2 - 28.0;
    final usaMaterial3 = Theme.of(tester.element(seletorHorario)).useMaterial3;

    // No mostrador de 24h do Material 3, 10 fica no anel externo,
    // na posição correspondente ao índice 10 de 12 posições.
    // No Material 2, o mostrador apresenta horas pares; 10 é o índice 5.
    final indiceHora = usaMaterial3 ? 10 : 5;
    final anguloHora = math.pi / 2 - indiceHora * (2 * math.pi / 12);
    await tester.tapAt(
      centroMostrador +
          Offset(raio * math.cos(anguloHora), -raio * math.sin(anguloHora)),
    );
    await tester.pumpAndSettle();

    // Depois da seleção da hora, o mostrador passa para os minutos.
    // 15 minutos corresponde à posição de 3 horas (à direita do centro).
    final retanguloMinutos = tester.getRect(mostrador);
    final centroMinutos = retanguloMinutos.center;
    final raioMinutos = retanguloMinutos.shortestSide / 2 - 28.0;
    await tester.tapAt(centroMinutos + Offset(raioMinutos, 0));
    await tester.pumpAndSettle();

    await tester.tap(find.descendant(
      of: seletorHorario,
      matching: find.text('Selecionar'),
    ));
    await tester.pumpAndSettle();
    expect(find.text('Horário: 10:15'), findsOneWidget);
    expect(find.text('Consulta de revisão'), findsOneWidget);
    painelUnico();
  });

  caso('cancelar a escolha de data conserva o valor anterior', (tester) async {
    await abrir(tester);
    await tester.tap(find.text('Escolher data'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('29').hitTestable());
    await tester.tap(find.text('Cancelar'));
    await tester.pumpAndSettle();
    painelUnico();
    expect(find.text('Data: 28/10/2026'), findsOneWidget);
  });

  for (final tamanho in [const Size(360, 640), const Size(393, 852)]) {
    caso('rodapé acessível com teclado em ${tamanho.width.toInt()} pixels',
        (tester) async {
      await abrir(tester, tamanho: tamanho);
      tester.view.viewInsets = const FakeViewPadding(bottom: 260);
      addTearDown(tester.view.resetViewInsets);
      await tester.pumpAndSettle();
      final salvar = find.text('Salvar formulário');
      expect(salvar.hitTestable(), findsOneWidget);
      expect(tester.getBottomLeft(salvar).dy, lessThan(tamanho.height - 260));
    });
  }
}

class _FormularioDeTeste extends StatefulWidget {
  const _FormularioDeTeste({this.aoReceber});

  final ValueChanged<String?>? aoReceber;

  @override
  State<_FormularioDeTeste> createState() => _FormularioDeTesteState();
}

class _FormularioDeTesteState extends State<_FormularioDeTeste> {
  final texto = TextEditingController();
  String recebido = '';
  DateTime data = DateTime(2026, 10, 28);
  TimeOfDay horario = const TimeOfDay(hour: 9, minute: 15);

  @override
  void dispose() {
    texto.dispose();
    super.dispose();
  }

  Future<void> proximaEtapa() async {
    final valor = await abrirModalFormulario<String>(
      context,
      builder: (context) => ModalFormulario(
        titulo: 'Escolha',
        conteudo: const Text('Outra etapa dentro do mesmo painel.'),
        rodape: FilledButton(
          onPressed: () => fecharEtapaModal(context, 'Escolhido'),
          child: const Text('Usar resultado'),
        ),
      ),
    );
    widget.aoReceber?.call(valor);
    if (mounted) setState(() => recebido = valor ?? 'Cancelado');
  }

  Future<void> escolherData() async {
    final nova = await abrirSeletorData(
      context: context,
      initialDate: data,
      firstDate: DateTime(2026),
      lastDate: DateTime(2030),
    );
    if (mounted && nova != null) setState(() => data = nova);
  }

  Future<void> escolherHorario() async {
    final novo =
        await abrirSeletorHorario(context: context, initialTime: horario);
    if (mounted && novo != null) setState(() => horario = novo);
  }

  @override
  Widget build(BuildContext context) {
    return ModalFormulario(
      titulo: 'Formulário',
      conteudo: Column(
        children: [
          TextField(controller: texto),
          TextButton(
              onPressed: proximaEtapa, child: const Text('Próxima etapa')),
          TextButton(
              onPressed: escolherData, child: const Text('Escolher data')),
          TextButton(
              onPressed: escolherHorario,
              child: const Text('Escolher horário')),
          Text('Recebido: $recebido'),
          Text('Data: ${data.day}/${data.month}/${data.year}'),
          Text(
              'Horário: ${horario.hour}:${horario.minute.toString().padLeft(2, '0')}'),
        ],
      ),
      rodape: FilledButton(
        onPressed: () => fecharEtapaModal(context, texto.text),
        child: const Text('Salvar formulário'),
      ),
    );
  }
}
