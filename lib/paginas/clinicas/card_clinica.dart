import 'package:flutter/material.dart';
import 'clinica.dart';
import 'package:pex/shared/estilo/estilo_texto.dart';
import 'package:pex/shared/listagem/card_listagem.dart';

class CardClinica extends StatelessWidget {
  const CardClinica({super.key, required this.clinica, this.aoClicar});

  final Clinica clinica;
  final VoidCallback? aoClicar;

  @override
  Widget build(BuildContext context) {
    return CardListagem(
      aoClicar: aoClicar,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      conteudo: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextoComEstilo(
                  clinica.nome,
                  cor: const Color(0xFF29363D),
                  tamanho: 18,
                  peso: FontWeight.bold,
                ),
                const SizedBox(height: 4),
                TextoComEstilo(
                  clinica.endereco,
                  cor: Colors.grey,
                  tamanho: 14,
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          const Icon(
            Icons.arrow_forward_ios,
            size: 20,
            color: Color(0xFF9E9E9E),
          ),
        ],
      ),
    );
  }
}
