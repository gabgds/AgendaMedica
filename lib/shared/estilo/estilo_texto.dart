// Fiz isso pra reduzir identação em algumas partes - Gustavo

import 'package:flutter/material.dart';

class TextoComEstilo extends StatelessWidget {
  const TextoComEstilo(
      this.texto, {
        super.key,
        required this.cor,
        this.tamanho = 14,
        this.peso = FontWeight.normal,
      });

  final String texto;
  final Color cor;
  final double tamanho;
  final FontWeight peso;

  @override
  Widget build(BuildContext context) {
    return Text(
      texto,
      style: TextStyle(
        color: cor,
        fontSize: tamanho,
        fontWeight: peso,
      ),
    );
  }
}