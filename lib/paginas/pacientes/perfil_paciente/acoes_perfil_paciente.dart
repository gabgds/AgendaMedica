import 'package:flutter/material.dart';
import 'package:pex/shared/botões/botao.dart';

// Rodapé do perfil. A escolha feita no cadastro controla o botão de notas.
class AcoesPerfilPaciente extends StatelessWidget {
  const AcoesPerfilPaciente({
    super.key,
    required this.emitirNotaFiscal,
    required this.aoAbrirNotasFiscais,
    required this.aoEditar,
    required this.aoRemover,
  });

  final bool emitirNotaFiscal;
  final VoidCallback aoAbrirNotasFiscais;
  final VoidCallback aoEditar;
  final VoidCallback aoRemover;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (emitirNotaFiscal) ...[
          SizedBox(
            height: 50,
            child: Button(
              'Notas fiscais',
              cor: const Color(0xFF009691),
              padding: EdgeInsets.zero,
              onPressed: aoAbrirNotasFiscais,
            ),
          ),
          const SizedBox(height: 18),
        ],
        SizedBox(
          height: 50,
          child: Button(
            'Editar paciente',
            cor: const Color(0xFF207CD4),
            padding: EdgeInsets.zero,
            onPressed: aoEditar,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 44,
          child: TextButton.icon(
            onPressed: aoRemover,
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFFFF3333),
              textStyle: const TextStyle(fontSize: 18),
            ),
            icon: const Icon(Icons.delete_outline, size: 22),
            label: const Text('Remover paciente'),
          ),
        ),
      ],
    );
  }
}
