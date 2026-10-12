import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// A mesma decoração pode ser usada por campos de texto e seletores.
// O modo compacto segue o layout dos modais, sem alterar os campos de login.
InputDecoration decoracaoCampoFormulario(
  String texto, {
  bool compacto = false,
  Widget? suffixIcon,
}) {
  return InputDecoration(
    hintText: texto,
    hintStyle: TextStyle(
      color: Colors.grey,
      fontSize: compacto ? 14 : null,
      fontWeight: FontWeight.bold,
    ),
    filled: true,
    fillColor: const Color(0xFFE9F0F6),
    isDense: compacto ? true : null,
    contentPadding: EdgeInsets.symmetric(
      horizontal: compacto ? 18 : 22,
      vertical: compacto ? 14 : 18,
    ),
    suffixIcon: suffixIcon,
    suffixIconConstraints: compacto
        ? const BoxConstraints(minWidth: 48, minHeight: 44)
        : null,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(compacto ? 14 : 16),
      borderSide: BorderSide.none,
    ),
  );
}

class FormInput extends StatelessWidget {
  const FormInput(
    this.text, {
    super.key,
    this.senha = false,
    this.teclado = TextInputType.text,
    this.controller,
    this.validator,
    this.compacto = false,
    this.readOnly = false,
    this.onTap,
    this.suffixIcon,
    this.inputFormatters,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
  });

  final String text;
  final bool senha;
  final TextInputType teclado;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final bool compacto;
  final bool readOnly;
  final VoidCallback? onTap;
  final Widget? suffixIcon;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputAction? textInputAction;
  final TextCapitalization textCapitalization;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: senha,
      keyboardType: teclado,
      validator: validator,
      readOnly: readOnly,
      onTap: onTap,
      inputFormatters: inputFormatters,
      textInputAction: textInputAction,
      textCapitalization: textCapitalization,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      style: compacto ? const TextStyle(fontSize: 14) : null,
      decoration: decoracaoCampoFormulario(
        text,
        compacto: compacto,
        suffixIcon: suffixIcon,
      ),
    );
  }
}
