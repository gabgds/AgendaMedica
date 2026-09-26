import 'package:flutter/material.dart';

class FormInput extends StatelessWidget {
  const FormInput(
      this.text, {
        super.key,
        this.senha = false,
        this.teclado = TextInputType.text,
        this.controller,
        this.validator,
      });

  final String text;
  final bool senha;
  final TextInputType teclado;
  final TextEditingController? controller;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: senha,
      keyboardType: teclado,
      validator: validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        hintText: text,
        hintStyle: const TextStyle(
          color: Colors.grey,
          fontWeight: FontWeight.bold,
        ),
        filled: true,
        fillColor: const Color(0xFFE9F0F6),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 22,
          vertical: 18,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}