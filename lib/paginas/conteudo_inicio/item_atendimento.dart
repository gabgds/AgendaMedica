// Isso aqui foi usado no dados_para_teste.dart

import 'package:flutter/material.dart';
import 'package:pex/shared/estilo/estilo_texto.dart';
import '../../shared/funcoes/obter_iniciais.dart';

class ItemAtendimento extends StatelessWidget {
  const ItemAtendimento({
    super.key,
    required this.nome,
    required this.horario,
    required this.local,
    required this.concluido,
    required this.onTap,
  });

  final String nome;
  final String horario;
  final String local;
  final bool concluido;
  final VoidCallback onTap;

  Color gerarCorAvatar(String nome) {
    const cores = [
      Color(0xFF1976D2),
      Color(0xFF6015EF),
      Color(0xFF00A859),
      Color(0xFFD84315),
      Color(0xFFC2185B),
    ];

    final soma = nome.trim().toLowerCase().runes.fold<int>(
      0,
          (total, letra) => total + letra,
    );

    return cores[soma % cores.length];
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 14,
      ),
      leading: CircleAvatar(
        backgroundColor: gerarCorAvatar(nome),
        child: TextoComEstilo(
          obterIniciais(nome),
          cor: Colors.white,
          tamanho: 18,
          peso: FontWeight.bold,
        ),
      ),
      title: TextoComEstilo(
        '$horario - $nome',
        cor: const Color(0xFF29363D),
        tamanho: 16,
        peso: FontWeight.bold,
      ),
      subtitle: TextoComEstilo(
        local,
        cor: Colors.grey,
        tamanho: 13,
      ),
      trailing: Icon(
        Icons.circle,
        size: 10,
        color: concluido
            ? const Color(0xFF1B8780)
            : const Color(0xFFFF914D),
      ),
    );
  }
}