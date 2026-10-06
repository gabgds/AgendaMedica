import 'package:flutter/material.dart';
import 'package:pex/shared/atendimento/atendimento.dart';
import 'package:pex/shared/estilo/estilo_texto.dart';
import 'package:pex/shared/funcoes/gerar_cor_avatar.dart';
import 'package:pex/shared/funcoes/obter_iniciais.dart';

// Cabeçalho do modal: seta de voltar, status e identificação do paciente.
class CabecalhoAtendimento extends StatelessWidget {
  const CabecalhoAtendimento({super.key, required this.atendimento});

  final Atendimento atendimento;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 10, 22, 22),
      child: Column(
        children: [
          barraSuperior(context),
          const SizedBox(height: 14),
          paciente(),
        ],
      ),
    );
  }

  Widget barraSuperior(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          tooltip: 'Voltar',
          icon: const Icon(Icons.arrow_back, color: Color(0xFF9E9E9E)),
          onPressed: () => Navigator.pop(context),
        ),
        etiquetaStatus(),
      ],
    );
  }

  Widget etiquetaStatus() {
    final concluido = atendimento.status == 'Concluído';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
      decoration: BoxDecoration(
        color: concluido ? const Color(0xFFE0F3EC) : const Color(0xFFE1EEFC),
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextoComEstilo(
        atendimento.status,
        cor: concluido ? const Color(0xFF00866A) : const Color(0xFF007AFF),
        tamanho: 14,
        peso: FontWeight.bold,
      ),
    );
  }

  Widget paciente() {
    final clinica = atendimento.clinicaId == null
        ? 'Avulso'
        : atendimento.nomeClinica;

    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: Row(
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: gerarCorAvatar(atendimento.nomePaciente),
            child: TextoComEstilo(
              obterIniciais(atendimento.nomePaciente),
              cor: Colors.white,
              tamanho: 20,
              peso: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextoComEstilo(
                  '${atendimento.horario} - ${atendimento.nomePaciente}',
                  cor: const Color(0xFF29363D),
                  tamanho: 20,
                  peso: FontWeight.bold,
                ),
                const SizedBox(height: 5),
                TextoComEstilo(clinica, cor: Colors.grey, tamanho: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
