import 'package:flutter/material.dart';
import 'package:pex/shared/formulario/modal_formulario.dart';
import 'package:pex/shared/listagem/card_listagem.dart';
import 'atendimento.dart';
import 'dados_em_memoria.dart';

Future<void> abrirModalNotasFiscais(
  BuildContext context, {
  int? pacienteId,
  bool apenasPendentes = false,
}) async {
  await abrirModalFormulario<void>(
    context,
    builder: (context) => ModalNotasFiscais(
      pacienteId: pacienteId,
      apenasPendentes: apenasPendentes,
    ),
  );
}

class ModalNotasFiscais extends StatefulWidget {
  const ModalNotasFiscais({
    super.key,
    this.pacienteId,
    this.apenasPendentes = false,
  });

  final int? pacienteId;
  final bool apenasPendentes;

  @override
  State<ModalNotasFiscais> createState() => _ModalNotasFiscaisState();
}

class _ModalNotasFiscaisState extends State<ModalNotasFiscais> {
  late final streamNotas = observarDadosEmMemoria(consultarNotas);
  bool confirmandoEmissao = false;

  List<Atendimento> consultarNotas() => notasFiscaisEmMemoria(
    pacienteId: widget.pacienteId,
    apenasPendentes: widget.apenasPendentes,
  );

  Future<void> marcarComoEmitida(Atendimento atendimento) async {
    if (confirmandoEmissao) return;
    confirmandoEmissao = true;
    try {
      final confirmado = await showDialog<bool>(
        context: context,
        builder: (contextDialogo) => AlertDialog(
          title: const Text('Confirmar emissão'),
          content: Text(
            'A nota fiscal de ${atendimento.nomePaciente}, referente ao '
            'atendimento de ${formatarData(atendimento.dataHora)} às '
            '${atendimento.horario}, já foi emitida?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(contextDialogo, false),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(contextDialogo, true),
              child: const Text('Sim, já foi emitida'),
            ),
          ],
        ),
      );
      if (!mounted || confirmado != true) return;
      if (!marcarNotaFiscalEmitidaEmMemoria(atendimento.id)) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nota fiscal marcada como emitida.')),
      );
    } finally {
      confirmandoEmissao = false;
    }
  }

  String formatarData(DateTime data) {
    final dia = data.day.toString().padLeft(2, '0');
    final mes = data.month.toString().padLeft(2, '0');
    return '$dia/$mes/${data.year}';
  }

  @override
  Widget build(BuildContext context) {
    return ModalFormulario(
      titulo: widget.apenasPendentes ? 'Notas fiscais pendentes' : 'Notas fiscais',
      conteudo: StreamBuilder<List<Atendimento>>(
        stream: streamNotas,
        initialData: consultarNotas(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text('Não foi possível carregar as notas fiscais.');
          }
          final notas = snapshot.data ?? <Atendimento>[];
          if (notas.isEmpty) {
            return Text(
              widget.apenasPendentes
                  ? 'Nenhuma nota fiscal pendente de emissão.'
                  : 'Nenhuma nota fiscal solicitada para este paciente.',
            );
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (final atendimento in notas)
                Padding(
                  padding: const EdgeInsets.only(bottom: 18),
                  child: cardNota(atendimento),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget cardNota(Atendimento atendimento) {
    final cor = atendimento.notaFiscalPendente
        ? const Color(0xFFB25D15)
        : atendimento.notaFiscalEmitida
        ? const Color(0xFF009691)
        : const Color(0xFF757575);

    return CardListagem(
      conteudo: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            atendimento.nomePaciente,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            '${formatarData(atendimento.dataHora)} às ${atendimento.horario}',
          ),
          const SizedBox(height: 4),
          Text(atendimento.local),
          const SizedBox(height: 12),
          Text(
            atendimento.situacaoNotaFiscal,
            style: TextStyle(color: cor, fontWeight: FontWeight.bold),
          ),
          if (atendimento.notaFiscalPendente) ...[
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () => marcarComoEmitida(atendimento),
              icon: const Icon(Icons.check),
              label: const Text('Marcar como emitida'),
            ),
          ],
        ],
      ),
    );
  }
}
