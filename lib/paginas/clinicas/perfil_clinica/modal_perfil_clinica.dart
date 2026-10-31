import 'package:pex/shared/formulario/confirmacao_modal.dart';
import 'package:pex/shared/avisos/aviso.dart';
import 'package:flutter/material.dart';
import 'package:pex/repositorios/clinicas_repositorio.dart';

import '../clinica.dart';

import 'package:pex/shared/formulario/modal_formulario.dart';

import '../formulario_clinica/modal_clinica.dart';
import 'acoes_perfil_clinica.dart';
import 'informacoes_perfil_clinica.dart';

Future<void> abrirModalPerfilClinica(
  BuildContext context, {
  required Clinica clinica,
}) async {
  await abrirModalFormulario<void>(
    context,
    builder: (context) => ModalPerfilClinica(clinica: clinica),
  );
}

class ModalPerfilClinica extends StatefulWidget {
  const ModalPerfilClinica({super.key, required this.clinica});

  final Clinica clinica;

  @override
  State<ModalPerfilClinica> createState() => _ModalPerfilClinicaState();
}

class _ModalPerfilClinicaState extends State<ModalPerfilClinica> {
  late Clinica clinica;
  bool acaoAberta = false;

  @override
  void initState() {
    super.initState();
    clinica = widget.clinica;
  }

  Future<void> editarClinica() async {
    if (acaoAberta) return;
    acaoAberta = true;
    try {
      final dados = await abrirModalClinica(context, clinicaInicial: clinica);
      if (!mounted || dados == null) return;
      final atualizada = await atualizarClinica(clinica.id, dados);
      if (!mounted) return;
      setState(() => clinica = atualizada);
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
        titulo: 'Remover clínica?',
        mensagem: 'Remover ${clinica.nome}? Os pacientes serão mantidos. '
            'Esta ação é irreversível.',
        textoConfirmar: 'Remover',
        destrutiva: true,
      );
      if (!mounted || confirmado != true) return;
      await removerClinica(clinica.id);
      if (mounted) fecharEtapaModal(context);
    } on ClinicaComAgendamentos catch (erro) {
      if (!mounted) return;
      mostrarAviso(context, erro.toString());
    } finally {
      acaoAberta = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ModalFormulario(
      titulo: clinica.nome,
      conteudo: InformacoesPerfilClinica(clinica: clinica),
      rodape: AcoesPerfilClinica(
        aoEditar: editarClinica,
        aoRemover: confirmarRemocao,
      ),
    );
  }
}
