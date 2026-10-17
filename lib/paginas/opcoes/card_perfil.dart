import 'package:flutter/material.dart';
import 'package:pex/shared/estilo/estilo_texto.dart';
import 'package:pex/shared/listagem/card_listagem.dart';

class CardPerfil extends StatelessWidget {
  const CardPerfil({super.key, required this.aoEditar});

  final VoidCallback aoEditar;

  @override
  Widget build(BuildContext context) {
    return CardListagem(
      aoClicar: aoEditar,
      padding: const EdgeInsets.fromLTRB(18, 14, 18, 18),
      conteudo: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const TextoComEstilo(
            'PERFIL',
            cor: Color(0xFF757575),
            tamanho: 14,
            peso: FontWeight.bold,
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: const Color(0xFFE9F0F6),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.person_outline,
                  size: 24,
                  color: Color(0xFF29363D),
                ),
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: TextoComEstilo(
                  'Editar dados pessoais',
                  cor: Color(0xFF29363D),
                  tamanho: 16,
                ),
              ),
              const SizedBox(width: 12),
              const Icon(
                Icons.arrow_forward_ios,
                color: Color(0xFF9E9E9E),
                size: 20,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
