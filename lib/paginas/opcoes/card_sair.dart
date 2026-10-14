import 'package:flutter/material.dart';
import 'package:pex/shared/estilo/estilo_texto.dart';
import 'package:pex/shared/listagem/card_listagem.dart';

class CardSair extends StatelessWidget {
  const CardSair({super.key, required this.aoSair});

  final VoidCallback aoSair;

  @override
  Widget build(BuildContext context) {
    return CardListagem(
      aoClicar: aoSair,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
      conteudo: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: const Color(0xFFFFBFC3),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.logout,
              color: Color(0xFFFF3333),
              size: 24,
            ),
          ),
          const SizedBox(width: 14),
          const TextoComEstilo(
            'Sair',
            cor: Color(0xFFFF3333),
            tamanho: 16,
            peso: FontWeight.bold,
          ),
        ],
      ),
    );
  }
}
