import 'package:flutter/material.dart';
import 'package:pex/shared/atendimento/atendimento.dart';
import 'package:pex/shared/formulario/modal_formulario.dart';
import 'acoes_atendimento.dart';
import 'cabecalho_atendimento.dart';
import 'informacoes_atendimento.dart';

// Abre os detalhes do atendimento selecionado na Agenda ou no Início.
Future<void> abrirModalAtendimento(
  BuildContext context, {
  required Atendimento atendimento,
  String? telefonePaciente,
}) async {
  await abrirModalFormulario<void>(
    context,
    builder: (context) => ModalAtendimento(
      atendimento: atendimento,
      telefonePaciente: telefonePaciente,
    ),
  );
}

// Junta cabeçalho, informações e botões usando a estrutura de modal do shared.
class ModalAtendimento extends StatelessWidget {
  const ModalAtendimento({
    super.key,
    required this.atendimento,
    this.telefonePaciente,
  });

  final Atendimento atendimento;
  final String? telefonePaciente;

  @override
  Widget build(BuildContext context) {
    return ModalFormulario(
      titulo: 'Atendimento',
      cabecalhoPersonalizado: CabecalhoAtendimento(atendimento: atendimento),
      conteudo: InformacoesAtendimento(
        atendimento: atendimento,
        telefonePaciente: telefonePaciente,
      ),
      rodape: const AcoesAtendimento(),
    );
  }
}
