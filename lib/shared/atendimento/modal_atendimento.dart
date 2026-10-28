import 'package:pex/shared/formulario/confirmacao_modal.dart';
import 'package:pex/shared/avisos/aviso.dart';
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
    mostrarAviso(context, mensagem);
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
    return abrirConfirmacaoModal(
      context,
      titulo: titulo,
      mensagem: mensagem,
      textoConfirmar: textoConfirmar,
      textoCancelar: textoCancelar,
      destrutiva: destrutiva,
    );
  }

  Future<void> editarAtendimento() async {
    if (acaoAberta || atendimentoAtual.status != StatusAgendamento.agendado) {
      return;
    }
    acaoAberta = true;
    try {
      final atendimento = atendimentoAtual;
      final pacientes = {
        for (final paciente in await listarPacientes())
          paciente.id: paciente.nome,
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
        titulo: 'Cancelar agendamento?',
        mensagem: 'Cancelar a consulta de '
            '${descreverAtendimento(atendimento)}?',
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
      mostrarAviso(context, 'Agendamento cancelado.');
      fecharEtapaModal(context);
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
        mensagem: 'Concluir a consulta de '
            '${descreverAtendimento(atendimento)}?$avisoNota',
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
          cabecalhoPersonalizado:
              CabecalhoAtendimento(atendimento: atendimento),
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
