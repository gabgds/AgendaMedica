// Isso aqui foi usado no dados_para_teste.dart

import 'package:flutter/material.dart';
import 'package:pex/shared/estilo/estilo_texto.dart';
import '../../shared/funcoes/obter_iniciais.dart';
import '../../shared/funcoes/gerar_cor_avatar.dart';
import '../../shared/atendimento/atendimento.dart';

class ItemAtendimento extends StatelessWidget {
  const ItemAtendimento({
    super.key,
    required this.atendimento,
    required this.onTap,
  });

  final Atendimento atendimento;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 14,
      ),
      leading: CircleAvatar(
        backgroundColor: gerarCorAvatar(atendimento.nomePaciente),
        child: TextoComEstilo(
          obterIniciais(atendimento.nomePaciente),
          cor: Colors.white,
          tamanho: 18,
          peso: FontWeight.bold,
        ),
      ),
      title: TextoComEstilo(
        '${atendimento.horario} - ${atendimento.nomePaciente}',
        cor: const Color(0xFF29363D),
        tamanho: 16,
        peso: FontWeight.bold,
      ),
      subtitle: TextoComEstilo(
        atendimento.local,
        cor: Colors.grey,
        tamanho: 13,
      ),
      trailing: Icon(
        Icons.circle,
        size: 10,
        color: atendimento.status == 'Concluído'
            ? const Color(0xFF1B8780)
            : const Color(0xFFFF914D),
      ),
    );
  }
}