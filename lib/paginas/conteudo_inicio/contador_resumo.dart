// Isso é um retângulo individual que mostra quantidade de atendimentos.
// Podem ser atendimentos totais do dia, concluídos ou restantes.

import 'package:flutter/material.dart';

class ContadorResumo extends StatelessWidget {
  const ContadorResumo({
    super.key,
    required this.titulo,
    required this.quantidade,
    required this.cor,
  });

  final String titulo;
  final int quantidade;
  final Color cor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF328783),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(
            '$quantidade',
            style: TextStyle(
              color: cor,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            titulo,
            style: const TextStyle(
              color: Color(0xFFA4F0EB),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}