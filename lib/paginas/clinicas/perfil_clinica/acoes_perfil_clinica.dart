import 'package:flutter/material.dart';
import 'package:pex/shared/botões/botao.dart';

class AcoesPerfilClinica extends StatelessWidget {
  const AcoesPerfilClinica({
    super.key,
    required this.aoEditar,
    required this.aoRemover,
  });

  final VoidCallback aoEditar;
  final VoidCallback aoRemover;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: 50,
          child: Button(
            'Editar clínica',
            cor: const Color(0xFF207CD4),
            padding: EdgeInsets.zero,
            onPressed: aoEditar,
          ),
        ),
        const SizedBox(height: 18),
        SizedBox(
          height: 44,
          child: TextButton.icon(
            onPressed: aoRemover,
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFFFF3333),
              textStyle: const TextStyle(fontSize: 18),
            ),
            icon: const Icon(Icons.delete_outline, size: 22),
            label: const Text('Remover clínica'),
          ),
        ),
      ],
    );
  }
}
