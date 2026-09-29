import 'package:flutter/material.dart';
import 'package:pex/shared/estilo/estilo_texto.dart';

class CardProximoAtendimento extends StatelessWidget {
  const CardProximoAtendimento({
    super.key,
    required this.horario,
    required this.paciente,
    required this.local,
    required this.descricao,
    required this.onTap,
  });

  final String horario;
  final String paciente;
  final String local;
  final String descricao;
  final VoidCallback onTap;

  static const Color ciano = Color(0xFF1B8780);

  // Card branco arredondado nos cantos
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      color: Colors.white,
      surfaceTintColor: Colors.transparent,
      elevation: 4,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: conteudoDoAtendimento(),
        ),
      ),
    );
  }

  // é o que junta o ícone do relógio com a coluna de informação em uma linha
  Widget conteudoDoAtendimento() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        iconeRelogio(),
        const SizedBox(width: 12),
        Expanded(child: informacoes()),
        const Icon(
          Icons.chevron_right,
          color: Colors.grey,
        ),
      ],
    );
  }

  Widget iconeRelogio() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFB4D4D3),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Icon(
        Icons.access_time,
        color: ciano,
      ),
    );
  }

  // Informações do próximo atendimento
  Widget informacoes() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextoComEstilo(
          'PRÓXIMO ATENDIMENTO',
          cor: Colors.grey[600]!,
          tamanho: 12,
        ),
        const SizedBox(height: 6),
        Wrap(
          spacing: 10,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            TextoComEstilo(
              horario,
              cor: ciano,
              tamanho: 22,
              peso: FontWeight.bold,
            ),
            TextoComEstilo(
              paciente,
              cor: Colors.black87,
              tamanho: 18,
              peso: FontWeight.bold,
            ),
          ],
        ),
        const SizedBox(height: 4),

        TextoComEstilo(local, cor: Colors.grey[600]!),
        const SizedBox(height: 4),

        TextoComEstilo(descricao, cor: Colors.grey[600]!, tamanho: 12),
      ],
    );
  }
}