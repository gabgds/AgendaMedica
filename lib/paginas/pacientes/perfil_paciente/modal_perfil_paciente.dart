import 'package:flutter/material.dart';
import 'package:pex/shared/estilo/estilo_texto.dart';
import 'package:pex/shared/formulario/modal_formulario.dart';
import 'package:pex/shared/paciente/dados_pacientes_em_memoria.dart';
import 'package:pex/shared/paciente/paciente.dart';
import '../formulario_paciente/modal_paciente.dart';
import 'acoes_perfil_paciente.dart';
import 'informacoes_perfil_paciente.dart';

Future<void> abrirModalPerfilPaciente(
  BuildContext context, {
  required Paciente paciente,
  required Map<int, String> clinicas,
  ValueChanged<Paciente>? aoAbrirNotasFiscais,
}) async {
  await abrirModalFormulario<void>(
    context,
    builder: (context) => ModalPerfilPaciente(
      paciente: paciente,
      clinicas: clinicas,
      aoAbrirNotasFiscais: aoAbrirNotasFiscais,
    ),
  );
}

class ModalPerfilPaciente extends StatefulWidget {
  const ModalPerfilPaciente({
    super.key,
    required this.paciente,
    required this.clinicas,
    this.aoAbrirNotasFiscais,
  });

  final Paciente paciente;
  final Map<int, String> clinicas;
  final ValueChanged<Paciente>? aoAbrirNotasFiscais;

  @override
  State<ModalPerfilPaciente> createState() => _ModalPerfilPacienteState();
}

class _ModalPerfilPacienteState extends State<ModalPerfilPaciente> {
  late Paciente paciente;
  bool acaoAberta = false;

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
        clinicas: widget.clinicas,
        pacienteInicial: paciente,
      );
      if (!mounted || dados == null) return;

      final atualizado = dados.paraPaciente(id: paciente.id);
      atualizarPacienteEmMemoria(atualizado);
      // Reavalia também a visibilidade de Notas fiscais ao salvar a edição.
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
    if (!paciente.emitirNotaFiscal || acaoAberta) return;
    acaoAberta = true;
    try {
      if (widget.aoAbrirNotasFiscais != null) {
        widget.aoAbrirNotasFiscais!(paciente);
        return;
      }

      // Estado vazio provisório. O callback permite conectar a tela de notas.
      await abrirModalFormulario<void>(
        context,
        builder: (context) => ModalFormulario(
          titulo: 'Notas fiscais',
          conteudo: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextoComEstilo(
                paciente.nome,
                cor: const Color(0xFF29363D),
                tamanho: 20,
                peso: FontWeight.bold,
              ),
              const SizedBox(height: 20),
              const TextoComEstilo(
                'Nenhuma nota fiscal cadastrada.',
                cor: Color(0xFF757575),
                tamanho: 16,
              ),
            ],
          ),
        ),
      );
    } finally {
      acaoAberta = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ModalFormulario(
      titulo: paciente.nome,
      conteudo: InformacoesPerfilPaciente(paciente: paciente),
      rodape: AcoesPerfilPaciente(
        emitirNotaFiscal: paciente.emitirNotaFiscal,
        aoAbrirNotasFiscais: abrirNotasFiscais,
        aoEditar: editarPaciente,
        aoRemover: removerPaciente,
      ),
    );
  }
}
