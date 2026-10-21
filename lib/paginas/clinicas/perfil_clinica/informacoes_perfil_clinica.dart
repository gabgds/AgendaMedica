import 'package:flutter/material.dart';
import '../clinica.dart';
import 'package:pex/shared/estilo/estilo_texto.dart';

class InformacoesPerfilClinica extends StatelessWidget {
  const InformacoesPerfilClinica({super.key, required this.clinica});

  final Clinica clinica;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 20),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF4F8),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          informacao('ENDEREÇO', clinica.endereco),
        ],
      ),
    );
  }

  Widget informacao(String titulo, String valor) {
    final preenchido = valor.trim().isNotEmpty;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: TextoComEstilo(
            titulo,
            cor: const Color(0xFF757575),
            tamanho: 13,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: TextoComEstilo(
            preenchido ? valor : 'Não informado',
            cor: preenchido ? const Color(0xFF29363D) : Colors.grey,
            tamanho: 14,
          ),
        ),
      ],
    );
  }
}
