import 'package:flutter/material.dart';
import 'package:pex/shared/atendimento/atendimento.dart';
import 'package:pex/shared/atendimento/dados_em_memoria.dart';
import 'package:pex/shared/atendimento/modal_notas_fiscais.dart';
import 'package:pex/shared/formulario/modal_formulario.dart';
import '../dados_pacientes_em_memoria.dart';
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
  late final streamNotasFiscais = observarDadosEmMemoria(
    () => notasFiscaisEmMemoria(pacienteId: widget.paciente.id),
  );

  @override
  void initState() {
    super.initState();
    paciente = widget.paciente;
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

      final atualizado = dados.paraPaciente(id: paciente.id);
      atualizarPacienteEmMemoria(atualizado);
      setState(() => paciente = atualizado);
    } finally {
      acaoAberta = false;
    }
  }

  Future<void> removerPaciente() async {
    if (acaoAberta) return;
    acaoAberta = true;
    try {
      final confirmado = await showDialog<bool>(
        context: context,
        builder: (contextDialogo) => AlertDialog(
          title: const Text('Remover paciente?'),
          content: Text('Deseja remover ${paciente.nome} da lista de pacientes?'),
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

      removerPacienteEmMemoria(paciente.id);
      Navigator.pop(context);
    } finally {
      acaoAberta = false;
    }
  }

  Future<void> abrirNotasFiscais() async {
    if (acaoAberta || notasFiscaisEmMemoria(pacienteId: paciente.id).isEmpty) {
      return;
    }
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
    return ModalFormulario(
      titulo: paciente.nome,
      conteudo: InformacoesPerfilPaciente(paciente: paciente),
      rodape: StreamBuilder<List<Atendimento>>(
        stream: streamNotasFiscais,
        initialData: notasFiscaisEmMemoria(pacienteId: paciente.id),
        builder: (context, snapshot) => AcoesPerfilPaciente(
          possuiNotasFiscais: snapshot.data?.isNotEmpty ?? false,
          aoAbrirNotasFiscais: abrirNotasFiscais,
          aoEditar: editarPaciente,
          aoRemover: removerPaciente,
        ),
      ),
    );
  }
}
