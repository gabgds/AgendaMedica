import 'package:flutter/material.dart';
import 'package:pex/database/status_agendamento.dart';
import 'package:pex/repositorios/agendamentos_repositorio.dart';
import 'package:pex/repositorios/clinicas_repositorio.dart';
import 'package:pex/repositorios/pacientes_repositorio.dart';
import 'package:pex/shared/formulario/modal_formulario.dart';
import 'package:pex/paginas/agenda/formulario_agenda/modal_agendamento.dart';
import 'package:pex/paginas/pacientes/paciente.dart';
import 'package:pex/paginas/pacientes/perfil_paciente/modal_perfil_paciente.dart';
import 'acoes_atendimento.dart';
import 'atendimento.dart';
import 'cabecalho_atendimento.dart';
import 'informacoes_atendimento.dart';

Future<void> abrirModalAtendimento(
  BuildContext context, {
  required Atendimento atendimento,
}) async {
  await abrirModalFormulario<void>(
    context,
    builder: (context) => ModalAtendimento(atendimento: atendimento),
  );
}

class ModalAtendimento extends StatefulWidget {
  const ModalAtendimento({super.key, required this.atendimento});

  final Atendimento atendimento;

  @override
  State<ModalAtendimento> createState() => _ModalAtendimentoState();
}

class _ModalAtendimentoState extends State<ModalAtendimento> {
  bool acaoAberta = false;
  late final streamAtendimento = observarAtendimento(widget.atendimento.id);
  late Atendimento atendimentoAtual = widget.atendimento;

  int? pacienteObservado;
  Stream<Paciente?>? streamPaciente;

  Stream<Paciente?> observarPacienteAtual() {
    if (pacienteObservado != atendimentoAtual.pacienteId) {
      pacienteObservado = atendimentoAtual.pacienteId;
      streamPaciente = observarPaciente(atendimentoAtual.pacienteId);
    }
    return streamPaciente!;
  }

  Future<void> abrirPerfilPaciente() async {
    if (acaoAberta) return;
    acaoAberta = true;
    try {
      final paciente = await buscarPaciente(atendimentoAtual.pacienteId);
      if (!mounted) return;
      if (paciente == null) {
        mostrarMensagem('Paciente não encontrado no cadastro.');
        return;
      }
      await abrirModalPerfilPaciente(context, paciente: paciente);
    } finally {
      acaoAberta = false;
    }
  }

  void mostrarMensagem(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensagem)),
    );
  }

  String descreverAtendimento(Atendimento atendimento) {
    final data = atendimento.dataHora;
    final dia = data.day.toString().padLeft(2, '0');
    final mes = data.month.toString().padLeft(2, '0');
    return '${atendimento.nomePaciente}, em $dia/$mes/${data.year} '
        'às ${atendimento.horario}';
  }

  Future<bool> confirmarAcao({
    required String titulo,
    required String mensagem,
    required String textoConfirmar,
    required String textoCancelar,
    bool destrutiva = false,
  }) async {
    final confirmado = await showDialog<bool>(
      context: context,
      builder: (contextDialogo) => AlertDialog(
        title: Text(titulo),
        content: Text(mensagem),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(contextDialogo, false),
            child: Text(textoCancelar),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(contextDialogo, true),
            style: destrutiva
                ? FilledButton.styleFrom(
                    backgroundColor: const Color(0xFFFF3333),
                    foregroundColor: Colors.white,
                  )
                : null,
            child: Text(textoConfirmar),
          ),
        ],
      ),
    );
    return confirmado == true;
  }

  Future<void> editarAtendimento() async {
    if (acaoAberta || atendimentoAtual.status != StatusAgendamento.agendado) {
      return;
    }
    acaoAberta = true;
    try {
      final atendimento = atendimentoAtual;
      final pacientes = {
        for (final paciente in await listarPacientes()) paciente.id: paciente.nome,
      };
      final clinicas = {
        for (final clinica in await listarClinicas()) clinica.id: clinica.nome,
      };
      if (!mounted) return;

      final dados = await abrirModalAgendamento(
        context,
        dataInicial: atendimento.dataHora,
        pacientes: pacientes,
        clinicas: clinicas,
        atendimentoInicial: atendimento,
      );
      if (!mounted || dados == null) return;

      final atualizado = await atualizarAtendimento(atendimento.id, dados);
      if (!mounted) return;
      mostrarMensagem(atualizado
          ? 'Agendamento atualizado.'
          : 'Não foi possível editar este agendamento.');
    } finally {
      acaoAberta = false;
    }
  }

  Future<void> cancelarAtendimentoAtual() async {
    if (acaoAberta || atendimentoAtual.status != StatusAgendamento.agendado) {
      return;
    }
    acaoAberta = true;
    try {
      final atendimento = atendimentoAtual;
      final confirmado = await confirmarAcao(
        titulo: 'Cancelar?',
        mensagem: 'Deseja cancelar o agendamento de '
            '${descreverAtendimento(atendimento)}? ',
        textoConfirmar: 'Cancelar',
        textoCancelar: 'Manter',
        destrutiva: true,
      );
      if (!mounted || !confirmado) return;
      final cancelado = await cancelarAtendimento(atendimento.id);
      if (!mounted) return;
      if (!cancelado) {
        mostrarMensagem('Não foi possível cancelar este agendamento.');
        return;
      }
      final mensagens = ScaffoldMessenger.of(context);
      Navigator.pop(context);
      mensagens.showSnackBar(
        const SnackBar(content: Text('Agendamento cancelado.')),
      );
    } finally {
      acaoAberta = false;
    }
  }

  Future<void> concluirAtendimentoAtual() async {
    if (acaoAberta || atendimentoAtual.status != StatusAgendamento.agendado) {
      return;
    }
    acaoAberta = true;
    try {
      final atendimento = atendimentoAtual;
      final avisoNota = atendimento.emitirNotaFiscal
          ? ' A nota fiscal ficará pendente de emissão.'
          : '';
      final confirmado = await confirmarAcao(
        titulo: 'Concluir atendimento?',
        mensagem: 'Deseja marcar o atendimento de '
            '${descreverAtendimento(atendimento)} como concluído?$avisoNota',
        textoConfirmar: 'Sim, concluir',
        textoCancelar: 'Voltar',
      );
      if (!mounted || !confirmado) return;
      final concluido = await concluirAtendimento(atendimento.id);
      if (!mounted) return;
      if (!concluido) {
        mostrarMensagem('Não foi possível concluir este atendimento.');
        return;
      }
      mostrarMensagem(atendimento.emitirNotaFiscal
          ? 'Atendimento concluído. Nota fiscal pendente de emissão.'
          : 'Atendimento concluído.');
    } finally {
      acaoAberta = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Atendimento?>(
      stream: streamAtendimento,
      initialData: widget.atendimento,
      builder: (context, snapshot) {
        atendimentoAtual = snapshot.data ?? atendimentoAtual;
        final atendimento = atendimentoAtual;
        return ModalFormulario(
          titulo: 'Atendimento',
          cabecalhoPersonalizado: CabecalhoAtendimento(atendimento: atendimento),
          conteudo: StreamBuilder<Paciente?>(
            stream: observarPacienteAtual(),
            builder: (context, snapshotPaciente) => InformacoesAtendimento(
              atendimento: atendimento,
              telefonePaciente: snapshotPaciente.data?.telefoneFormatado,
              aoAbrirPerfilPaciente: abrirPerfilPaciente,
            ),
          ),
          rodape: AcoesAtendimento(
            concluido: atendimento.status == StatusAgendamento.concluido,
            cancelado: atendimento.status == StatusAgendamento.cancelado,
            aoConcluir: concluirAtendimentoAtual,
            aoEditar: editarAtendimento,
            aoCancelar: cancelarAtendimentoAtual,
          ),
        );
      },
    );
  }
}
