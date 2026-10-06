import 'package:flutter/material.dart';
import 'package:pex/shared/botões/botao.dart';

// Rodapé visual do modal. As ações serão implementadas posteriormente.
class AcoesAtendimento extends StatelessWidget {
  const AcoesAtendimento({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: 46,
          child: Button(
            'Marcar como concluído',
            padding: EdgeInsets.zero,
            onPressed: () {},
          ),
        ),
        const SizedBox(height: 16),
        botaoEditar(),
        const SizedBox(height: 8),
        botaoCancelar(),
      ],
    );
  }

  Widget botaoEditar() {
    return SizedBox(
      height: 46,
      child: Button(
        'Editar agendamento',
        cor: const Color(0xFF207CD4),
        padding: EdgeInsets.zero,
        onPressed: () {},
      ),
    );
  }

  Widget botaoCancelar() {
    return SizedBox(
      height: 40,
      child: TextButton(
        onPressed: () {},
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
