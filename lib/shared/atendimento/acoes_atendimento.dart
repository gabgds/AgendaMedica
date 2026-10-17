import 'package:flutter/material.dart';
import 'package:pex/shared/botões/botao.dart';

// Ações do agendamento. Atendimentos concluídos ou cancelados exibem Fechar.
class AcoesAtendimento extends StatelessWidget {
  const AcoesAtendimento({
    super.key,
    this.concluido = false,
    this.cancelado = false,
    this.aoConcluir,
    this.aoEditar,
    this.aoCancelar,
  });

  final bool concluido;
  final bool cancelado;
  final VoidCallback? aoConcluir;
  final VoidCallback? aoEditar;
  final VoidCallback? aoCancelar;

  @override
  Widget build(BuildContext context) {
    if (concluido || cancelado) return botaoFechar(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: 46,
          child: Button(
            'Marcar como concluído',
            padding: EdgeInsets.zero,
            onPressed: aoConcluir,
          ),
        ),
        const SizedBox(height: 16),
        botaoEditar(),
        const SizedBox(height: 8),
        botaoCancelar(),
      ],
    );
  }

  Widget botaoFechar(BuildContext context) {
    return SizedBox(
      height: 46,
      child: Button(
        'Fechar',
        cor: const Color(0xFFCFCFCF),
        corTexto: Colors.black,
        pesoTexto: FontWeight.normal,
        padding: EdgeInsets.zero,
        onPressed: () => Navigator.pop(context),
      ),
    );
  }

  Widget botaoEditar() {
    return SizedBox(
      height: 46,
      child: Button(
        'Editar agendamento',
        cor: const Color(0xFF207CD4),
        padding: EdgeInsets.zero,
        onPressed: aoEditar,
      ),
    );
  }

  Widget botaoCancelar() {
    return SizedBox(
      height: 40,
      child: TextButton(
        onPressed: aoCancelar,
        style: TextButton.styleFrom(foregroundColor: const Color(0xFFFF3333)),
        child: const Text(
          'Cancelar agendamento',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
