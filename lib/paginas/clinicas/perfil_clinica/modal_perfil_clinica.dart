import 'package:flutter/material.dart';
import '../clinica.dart';
import '../dados_clinicas_em_memoria.dart';
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
      final atualizada = dados.paraClinica(id: clinica.id);
      atualizarClinicaEmMemoria(atualizada);
      setState(() => clinica = atualizada);
    } finally {
      acaoAberta = false;
    }
  }

  Future<void> removerClinica() async {
    if (acaoAberta) return;
    acaoAberta = true;
    try {
      final confirmado = await showDialog<bool>(
        context: context,
        builder: (contextDialogo) => AlertDialog(
          title: const Text('Remover clínica?'),
          content: Text('Deseja remover ${clinica.nome} da lista de clínicas?'),
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
      removerClinicaEmMemoria(clinica.id);
      Navigator.pop(context);
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
        aoRemover: removerClinica,
      ),
    );
  }
}
