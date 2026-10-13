import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  const Button(
    this.text, {
    super.key,
    required this.onPressed,
    this.cor = const Color(0xFF1B8780),
    this.corTexto = Colors.white,
    this.pesoTexto = FontWeight.bold,
    this.tamanhoTexto = 18,
    this.padding = const EdgeInsets.symmetric(vertical: 22),
  });

  final String text;
  final VoidCallback? onPressed;
  final Color cor;
  final Color corTexto;
  final FontWeight pesoTexto;
  final double tamanhoTexto;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: cor,
          foregroundColor: corTexto,
          padding: padding,
          textStyle: TextStyle(
            fontSize: tamanhoTexto,
            fontWeight: pesoTexto,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Text(text),
      ),
    );
  }
}
