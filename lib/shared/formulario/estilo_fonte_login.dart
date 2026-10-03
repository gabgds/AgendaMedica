import 'package:flutter/material.dart';

class LoginFontStyle extends StatelessWidget {
  const LoginFontStyle(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(text, style: TextStyle(
      color: Colors.black87,
      fontWeight: FontWeight.bold,
      fontSize: 28,
    ));
  }
}

class Subtitulo extends StatelessWidget {
  const Subtitulo(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(text, style: TextStyle(
      color: Colors.black87,
      fontSize: 18,
      fontWeight: FontWeight.normal,
    ));
  }
}
