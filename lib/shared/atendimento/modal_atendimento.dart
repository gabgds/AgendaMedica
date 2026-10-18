import 'package:flutter/material.dart';
import 'package:pex/shared/formulario/modal_formulario.dart';
import 'package:pex/paginas/agenda/formulario_agenda/modal_agendamento.dart';
import 'package:pex/paginas/agenda/formulario_agenda/dados_agendamento_teste.dart';
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
  bool acaoAberta = false;
  late final streamAtendimento = observarDadosEmMemoria(
    () => atendimentoAtual,
  );

  Atendimento get atendimentoAtual =>
      atendimentoPorIdEmMemoria(widget.atendimento.id) ?? widget.atendimento;

  Paciente? obterPacienteAtual() {
    for (final paciente in pacientesEmMemoria(pacientesTeste)) {
      if (paciente.id == atendimentoAtual.pacienteId) return paciente;
    }
    return null;
  }

  Future<void> abrirPerfilPaciente() async {
    if (acaoAberta) return;
    final paciente = obterPacienteAtual();
    if (paciente == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Paciente não encontrado no cadastro.')),
      );
      return;
    }

    acaoAberta = true;
    try {
      await abrirModalPerfilPaciente(context, paciente: paciente);
      if (!mounted) return;
      setState(() {});
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
    if (acaoAberta || atendimentoAtual.status != 'Agendado') return;
    acaoAberta = true;
    try {
      final atendimento = atendimentoAtual;
      final pacientes = <int, String>{...pacientesAgendamentoTeste};
      final clinicas = <int, String>{...clinicasAgendamentoTeste};
      pacientes.putIfAbsent(atendimento.pacienteId, () => atendimento.nomePaciente);
      final clinicaId = atendimento.clinicaId;
      if (clinicaId != null) {
        clinicas.putIfAbsent(clinicaId, () => atendimento.nomeClinica);
      }

      final dados = await abrirModalAgendamento(
        context,
        dataInicial: atendimento.dataHora,
        pacientes: pacientes,
        clinicas: clinicas,
        atendimentoInicial: atendimento,
      );
      if (!mounted || dados == null) return;

      final atualizado = atualizarAtendimentoEmMemoria(
        id: atendimento.id,
        pacienteId: dados.pacienteId,
        clinicaId: dados.clinicaId,
        nomePaciente: pacientes[dados.pacienteId]!,
        nomeClinica: dados.clinicaId == null ? '' : clinicas[dados.clinicaId]!,
        dataHora: dados.dataHora,
        duracaoMinutos: dados.duracaoMinutos,
        emitirNotaFiscal: dados.emitirNotaFiscal,
      );
      mostrarMensagem(atualizado
          ? 'Agendamento atualizado.'
          : 'Não foi possível editar este agendamento.');
    } finally {
      acaoAberta = false;
    }
  }

  Future<void> cancelarAtendimento() async {
    if (acaoAberta || atendimentoAtual.status != 'Agendado') return;
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
      if (!cancelarAtendimentoEmMemoria(atendimento.id)) {
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

  Future<void> concluirAtendimento() async {
    if (acaoAberta || atendimentoAtual.status != 'Agendado') return;
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
      if (!concluirAtendimentoEmMemoria(atendimento.id)) {
        mostrarMensagem('Não foi possível concluir este atendimento.');
        return;
      }
      mostrarMensagem(atendimentoAtual.notaFiscalPendente
          ? 'Atendimento concluído. Nota fiscal pendente de emissão.'
          : 'Atendimento concluído.');
    } finally {
      acaoAberta = false;
    }
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
            cancelado: atendimento.status == 'Cancelado',
            aoConcluir: concluirAtendimento,
            aoEditar: editarAtendimento,
            aoCancelar: cancelarAtendimento,
          ),
        );
      },
    );
  }
}
