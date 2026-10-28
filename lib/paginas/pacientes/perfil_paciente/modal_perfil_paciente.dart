import 'package:pex/shared/formulario/confirmacao_modal.dart';
import 'package:pex/shared/avisos/aviso.dart';
import 'package:flutter/material.dart';
import 'package:pex/repositorios/agendamentos_repositorio.dart';
import 'package:pex/repositorios/pacientes_repositorio.dart';
import 'package:pex/shared/atendimento/atendimento.dart';
import 'package:pex/shared/atendimento/modal_notas_fiscais.dart';
import 'package:pex/shared/formulario/modal_formulario.dart';

import '../paciente.dart';
import '../formulario_paciente/modal_paciente.dart';
import 'acoes_perfil_paciente.dart';
import 'informacoes_perfil_paciente.dart';

Future<void> abrirModalPerfilPaciente(
  BuildContext context, {
  required Paciente paciente,
  ValueChanged<Paciente>? aoAbrirNotasFiscais,
}) async {
  await abrirModalFormulario<void>(
    context,
    builder: (context) => ModalPerfilPaciente(
      paciente: paciente,
      aoAbrirNotasFiscais: aoAbrirNotasFiscais,
    ),
  );
}

class ModalPerfilPaciente extends StatefulWidget {
  const ModalPerfilPaciente({
    super.key,
    required this.paciente,
    this.aoAbrirNotasFiscais,
  });

  final Paciente paciente;
  final ValueChanged<Paciente>? aoAbrirNotasFiscais;

  @override
  State<ModalPerfilPaciente> createState() => _ModalPerfilPacienteState();
}

class _ModalPerfilPacienteState extends State<ModalPerfilPaciente> {
  late Paciente paciente;
  bool acaoAberta = false;
  late final streamPaciente = observarPaciente(widget.paciente.id);
  late final streamNotasFiscais = observarNotasFiscais(
    pacienteId: widget.paciente.id,
  );

  @override
  void initState() {
    super.initState();
    paciente = widget.paciente;
  }

  void mostrarMensagem(String mensagem) {
    mostrarAviso(context, mensagem);
  }

  Future<void> editarPaciente() async {
    if (acaoAberta) return;
    acaoAberta = true;
    try {
      final dados = await abrirModalPaciente(
        context,
        pacienteInicial: paciente,
      );
      if (!mounted || dados == null) return;

      await atualizarPaciente(paciente.id, dados);
    } on CpfJaCadastrado catch (erro) {
      if (mounted) mostrarMensagem(erro.toString());
    } finally {
      acaoAberta = false;
    }
  }

  Future<void> confirmarRemocao() async {
    if (acaoAberta) return;
    acaoAberta = true;
    try {
      final confirmado = await abrirConfirmacaoModal(
        context,
        titulo: 'Remover paciente?',
        mensagem: 'Remover ${paciente.nome} e todo o histórico de atendimentos '
            'e notas fiscais? Esta ação é irreversível.',
        textoConfirmar: 'Remover',
        destrutiva: true,
      );
      if (!mounted || confirmado != true) return;

      await removerPaciente(paciente.id);
      if (mounted) fecharEtapaModal(context);
    } on PacienteComAgendamentos catch (erro) {
      if (mounted) mostrarMensagem(erro.toString());
    } on PacienteComNotaPendente catch (erro) {
      if (mounted) mostrarMensagem(erro.toString());
    } finally {
      acaoAberta = false;
    }
  }

  Future<void> abrirNotasFiscais() async {
    if (acaoAberta) return;
    acaoAberta = true;
    try {
      if (widget.aoAbrirNotasFiscais != null) {
        widget.aoAbrirNotasFiscais!(paciente);
        return;
      }

      await abrirModalNotasFiscais(context, pacienteId: paciente.id);
    } finally {
      acaoAberta = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Paciente?>(
      stream: streamPaciente,
      initialData: widget.paciente,
      builder: (context, snapshot) {
        paciente = snapshot.data ?? paciente;
        return ModalFormulario(
          titulo: paciente.nome,
          conteudo: InformacoesPerfilPaciente(paciente: paciente),
          rodape: StreamBuilder<List<Atendimento>>(
            stream: streamNotasFiscais,
            builder: (context, snapshot) => AcoesPerfilPaciente(
              possuiNotasFiscais: snapshot.data?.isNotEmpty ?? false,
              aoAbrirNotasFiscais: abrirNotasFiscais,
              aoEditar: editarPaciente,
              aoRemover: confirmarRemocao,
            ),
          ),
        );
      },
    );
  }
}
