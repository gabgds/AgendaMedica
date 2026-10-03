import 'package:flutter/material.dart';
import '../../shared/estilo/estilo_texto.dart';
import '../../shared/funcoes/obter_iniciais.dart';
import '../../shared/funcoes/gerar_cor_avatar.dart';
import '../../shared/atendimento/atendimento.dart';

class CardAtendimento extends StatelessWidget {
  const CardAtendimento({
    super.key,
    required this.atendimento,
    required this.onTap,
  });

  final Atendimento atendimento;
  final VoidCallback onTap;

  static final Color cinza = Colors.grey[700]!;

  // O card junta avatar() e informacoes() numa row
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      color: Colors.white,
      surfaceTintColor: Colors.transparent,
      elevation: 4,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              avatar(),
              const SizedBox(width: 12),
              Expanded(child: informacoes()),
              const Icon(Icons.chevron_right, color: Colors.grey, size: 28),
            ],
          ),
        ),
      ),
    );
  }

  // ícone com as iniciais
  Widget avatar() {
    return Container(
      width: 48,
      height: 48,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: gerarCorAvatar(atendimento.nomePaciente),
        borderRadius: BorderRadius.circular(16),
      ),
      child: TextoComEstilo(
        obterIniciais(atendimento.nomePaciente),
        cor: Colors.white,
        tamanho: 20,
        peso: FontWeight.bold,
      ),
    );
  }

  // coluna de informações do atendimento
  Widget informacoes() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 10,
          crossAxisAlignment: WrapCrossAlignment.center,
          // primeira linha, horário e nome
          children: [
            TextoComEstilo(
              atendimento.horario,
              cor: const Color(0xFF1B8780),
              tamanho: 20,
              peso: FontWeight.bold,
            ),
            TextoComEstilo(
              atendimento.nomePaciente,
              cor: const Color(0xFF29363D),
              tamanho: 18,
              peso: FontWeight.bold,
            ),
          ],
        ),
        const SizedBox(height: 8),
        // segunda linha, local
        TextoComEstilo(atendimento.local, cor: cinza, tamanho: 14),
        const SizedBox(height: 10),
        Wrap(
          spacing: 4,
          runSpacing: 4,
          crossAxisAlignment: WrapCrossAlignment.center,
          // terceira linha, etiqueta e minutos
          children: [
            etiqueta(),
            TextoComEstilo('${atendimento.duracaoMinutos} min', cor: cinza, tamanho: 12),
          ],
        ),
      ],
    );
  }

  Widget etiqueta() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFE1EEFC),
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextoComEstilo(
        atendimento.status,
        cor: const Color(0xFF007AFF),
        tamanho: 10,
        peso: FontWeight.bold,
      ),
    );
  }
}
