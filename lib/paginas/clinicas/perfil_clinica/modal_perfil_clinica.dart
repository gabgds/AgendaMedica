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
      final confirmado = await showDialog<bool>(
        context: context,
        builder: (contextDialogo) => AlertDialog(
          title: const Text('Remover clínica?'),
          content: Text(
            'Deseja remover ${clinica.nome} da lista de clínicas? '
            'Os cadastros dos pacientes serão mantidos. '
            'Agendamentos cancelados não impedem a remoção. '
            'Esta ação não pode ser desfeita.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(contextDialogo, false),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(contextDialogo, true),
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFFFF3333),
              ),
              child: const Text('Remover'),
            ),
          ],
        ),
      );
      if (!mounted || confirmado != true) return;
      await removerClinica(clinica.id);
      if (mounted) Navigator.pop(context);
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
