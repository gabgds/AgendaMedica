import 'package:flutter/material.dart';
import 'package:pex/shared/formulario/modal_formulario.dart';
import 'package:pex/paginas/pacientes/paciente.dart';
import 'package:pex/paginas/pacientes/dados_pacientes_em_memoria.dart';
import 'package:pex/paginas/pacientes/dados_pacientes_teste.dart';
import 'package:pex/paginas/pacientes/perfil_paciente/modal_perfil_paciente.dart';
import 'acoes_atendimento.dart';
import 'atendimento.dart';
import 'cabecalho_atendimento.dart';
import 'dados_em_memoria.dart';
import 'informacoes_atendimento.dart';

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

class ModalAtendimento extends StatefulWidget {
  const ModalAtendimento({
    super.key,
    required this.atendimento,
    this.telefonePaciente,
  });

  final Atendimento atendimento;
  final String? telefonePaciente;

  @override
  State<ModalAtendimento> createState() => _ModalAtendimentoState();
}

class _ModalAtendimentoState extends State<ModalAtendimento> {
  bool perfilAberto = false;
  late final streamAtendimento = observarDadosEmMemoria(
    () => atendimentoPorIdEmMemoria(widget.atendimento.id) ?? widget.atendimento,
  );

  Paciente? obterPacienteAtual() {
    for (final paciente in pacientesEmMemoria(pacientesTeste)) {
      if (paciente.id == widget.atendimento.pacienteId) return paciente;
    }
    return null;
  }

  Future<void> abrirPerfilPaciente() async {
    if (perfilAberto) return;
    final paciente = obterPacienteAtual();
    if (paciente == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Paciente não encontrado no cadastro.')),
      );
      return;
    }

    perfilAberto = true;
    try {
      await abrirModalPerfilPaciente(context, paciente: paciente);
      if (!mounted) return;
      // Reconsulta o cadastro para refletir edições de telefone e remoções.
      setState(() {});
    } finally {
      perfilAberto = false;
    }
  }

  void concluirAtendimento() {
    if (!concluirAtendimentoEmMemoria(widget.atendimento.id)) return;
    final atendimento = atendimentoPorIdEmMemoria(widget.atendimento.id)!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          atendimento.notaFiscalPendente
              ? 'Atendimento concluído. Nota fiscal pendente de emissão.'
              : 'Atendimento concluído.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Atendimento>(
      stream: streamAtendimento,
      initialData: widget.atendimento,
      builder: (context, snapshot) {
        final atendimento = snapshot.data ?? widget.atendimento;
        final paciente = obterPacienteAtual();
        return ModalFormulario(
          titulo: 'Atendimento',
          cabecalhoPersonalizado: CabecalhoAtendimento(atendimento: atendimento),
          conteudo: InformacoesAtendimento(
            atendimento: atendimento,
            telefonePaciente:
                paciente?.telefoneFormatado ?? widget.telefonePaciente,
            aoAbrirPerfilPaciente: abrirPerfilPaciente,
          ),
          rodape: AcoesAtendimento(
            concluido: atendimento.status == 'Concluído',
            aoConcluir: concluirAtendimento,
          ),
        );
      },
    );
  }
}
