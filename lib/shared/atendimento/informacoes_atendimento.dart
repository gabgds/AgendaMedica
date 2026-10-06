import 'package:flutter/material.dart';
import 'package:pex/shared/atendimento/atendimento.dart';
import 'package:pex/shared/estilo/estilo_texto.dart';
import 'package:pex/shared/funcoes/gerar_cor_avatar.dart';
import 'package:pex/shared/funcoes/obter_iniciais.dart';

// Exibe os dados da consulta e a apresentação do perfil do paciente.
// O telefone é opcional porque ainda não está disponível em Atendimento.
class InformacoesAtendimento extends StatelessWidget {
  const InformacoesAtendimento({
    super.key,
    required this.atendimento,
    this.telefonePaciente,
  });

  final Atendimento atendimento;
  final String? telefonePaciente;

  static const fundo = Color(0xFFEEF4F8);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        dadosConsulta(),
        const SizedBox(height: 20),
        perfilPaciente(),
      ],
    );
  }

  Widget dadosConsulta() {
    final clinica = atendimento.clinicaId == null
        ? 'Avulso'
        : atendimento.nomeClinica;
    final sala = atendimento.sala.trim().isEmpty
        ? 'Não informada'
        : 'Sala ${atendimento.sala}';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
      decoration: BoxDecoration(
        color: fundo,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        children: [
          linha('DATA', formatarData(atendimento.dataHora)),
          linha('HORÁRIO', atendimento.horario),
          linha('DURAÇÃO', '${atendimento.duracaoMinutos} minutos'),
          linha('SALA', sala),
          linha('CLÍNICA', clinica),
        ],
      ),
    );
  }

  Widget linha(String rotulo, String valor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: TextoComEstilo(rotulo, cor: Colors.grey, tamanho: 14),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: Text(
              valor,
              textAlign: TextAlign.right,
              style: const TextStyle(fontSize: 16, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  Widget perfilPaciente() {
    final telefone = telefonePaciente?.trim();
    final textoTelefone = telefone == null || telefone.isEmpty
        ? 'Telefone não informado'
        : telefone;

    return Material(
      color: fundo,
      borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        // Por enquanto, o perfil tem somente aparência.
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          child: Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: gerarCorAvatar(atendimento.nomePaciente),
                child: TextoComEstilo(
                  obterIniciais(atendimento.nomePaciente),
                  cor: Colors.white,
                  tamanho: 16,
                  peso: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const TextoComEstilo(
                      'Perfil do paciente',
                      cor: Colors.black,
                      tamanho: 16,
                      peso: FontWeight.bold,
                    ),
                    const SizedBox(height: 3),
                    TextoComEstilo(textoTelefone, cor: Colors.grey, tamanho: 12),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.grey, size: 22),
            ],
          ),
        ),
      ),
    );
  }

  String formatarData(DateTime data) {
    final dia = data.day.toString().padLeft(2, '0');
    final mes = data.month.toString().padLeft(2, '0');
    return '$dia/$mes/${data.year}';
  }
}
