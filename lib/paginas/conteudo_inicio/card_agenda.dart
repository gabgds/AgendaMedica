import 'package:flutter/material.dart';
import 'package:pex/shared/estilo/estilo_texto.dart';

class CardAgenda extends StatelessWidget {
  const CardAgenda({
    super.key,
    required this.data,
    required this.atendimentos,
  });

  final String data;

  // o snapshot da variável stream vem parar nessa lista
  // a lista de ItemAtendimento que vem do conteudo_inicio.dart vem parar aqui
  // passando pelo snapshot e chegando nessa lista atendimentos
  final List<Widget> atendimentos;

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
      child: Column(
        children: [
          cabecalho(),
          for (final atendimento in atendimentos) ...[
            const Divider(
              height: 1,
              color: Color(0xFFE0E0E0),
            ),
            atendimento,
          ],
        ],
      ),
    );
  }

  Widget cabecalho() {
    return Padding(
      padding: const EdgeInsets.all(18),
      child: Row(
        children: [
          Expanded(child: titulo()),
          const SizedBox(width: 12),
        ],
      ),
    );
  }

  Widget titulo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TextoComEstilo(
          'Agenda de hoje',
          cor: Colors.black,
          tamanho: 20,
          peso: FontWeight.bold,
        ),
        const SizedBox(height: 6),
        TextoComEstilo(
          data,
          cor: Colors.grey,
          tamanho: 16,
        ),
      ],
    );
  }
}