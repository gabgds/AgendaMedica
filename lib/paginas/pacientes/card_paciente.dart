import 'package:flutter/material.dart';
import 'package:pex/shared/estilo/estilo_texto.dart';
import 'package:pex/shared/funcoes/gerar_cor_avatar.dart';
import 'package:pex/shared/funcoes/obter_iniciais.dart';
import 'package:pex/shared/paciente/paciente.dart';
import 'package:pex/shared/listagem/card_listagem.dart';

// Card com a identificação do paciente e espaço para uma ação ao clicar.
class CardPaciente extends StatelessWidget {
  const CardPaciente({
    super.key,
    required this.paciente,
    this.aoClicar,
  });

  final Paciente paciente;
  final VoidCallback? aoClicar;

  @override
  Widget build(BuildContext context) {
    return CardListagem(
      aoClicar: aoClicar,
      conteudo: Row(
        children: [
          avatar(),
          const SizedBox(width: 14),
          Expanded(child: informacoes()),
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

  Widget avatar() {
    return Container(
      width: 48,
      height: 48,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: gerarCorAvatar(paciente.nome),
        borderRadius: BorderRadius.circular(14),
      ),
      child: TextoComEstilo(
        obterIniciais(paciente.nome),
        cor: Colors.white,
        tamanho: 20,
        peso: FontWeight.bold,
      ),
    );
  }

  Widget informacoes() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextoComEstilo(
          paciente.nome,
          cor: const Color(0xFF29363D),
          tamanho: 20,
          peso: FontWeight.bold,
        ),
        TextoComEstilo(paciente.telefone, cor: Colors.grey, tamanho: 14),
      ],
    );
  }
}
