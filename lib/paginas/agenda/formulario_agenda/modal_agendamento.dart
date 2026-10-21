import 'package:flutter/material.dart';
import '../../../shared/botões/botao.dart';
import '../../../shared/formulario/modal_formulario.dart';
import '../../../shared/atendimento/atendimento.dart';
import 'campos_agendamento.dart';
import 'novo_agendamento.dart';

Future<NovoAgendamento?> abrirModalAgendamento(
  BuildContext context, {
  required DateTime dataInicial,
  required Map<int, String> pacientes,
  required Map<int, String> clinicas,
  Atendimento? atendimentoInicial,
}) {
  return abrirModalFormulario<NovoAgendamento>(
    context,
    builder: (context) => ModalAgendamento(
      dataInicial: dataInicial,
      pacientes: pacientes,
      clinicas: clinicas,
      atendimentoInicial: atendimentoInicial,
    ),
  );
}

class ModalAgendamento extends StatefulWidget {
  const ModalAgendamento({
    super.key,
    required this.dataInicial,
    required this.pacientes,
    required this.clinicas,
    this.atendimentoInicial,
  });

  final DateTime dataInicial;
  final Map<int, String> pacientes;
  final Map<int, String> clinicas;
  final Atendimento? atendimentoInicial;

  @override
  State<ModalAgendamento> createState() => _ModalAgendamentoState();
}

class _ModalAgendamentoState extends State<ModalAgendamento> {
  final chaveFormulario = GlobalKey<FormState>();
  final dataController = TextEditingController();
  final horarioController = TextEditingController();
  final duracaoController = TextEditingController();
  final salaController = TextEditingController();

  int? pacienteId;
  int? clinicaId;
  bool? emitirNotaFiscal;
  late DateTime dataSelecionada;
  TimeOfDay? horarioSelecionado;

  @override
  void initState() {
    super.initState();
    final atendimento = widget.atendimentoInicial;
    dataSelecionada = DateUtils.dateOnly(
      atendimento?.dataHora ?? widget.dataInicial,
    );
    if (atendimento != null) {
      pacienteId = atendimento.pacienteId;
      clinicaId = atendimento.clinicaId ?? 0;
      emitirNotaFiscal = atendimento.emitirNotaFiscal;
      horarioSelecionado = TimeOfDay.fromDateTime(atendimento.dataHora);
      horarioController.text = atendimento.horario;
      duracaoController.text = atendimento.duracaoMinutos.toString();
      salaController.text = atendimento.sala;
    }
    atualizarTextoData();
  }

  @override
  void dispose() {
    dataController.dispose();
    horarioController.dispose();
    duracaoController.dispose();
    salaController.dispose();
    super.dispose();
  }

  void atualizarTextoData() {
    final dia = dataSelecionada.day.toString().padLeft(2, '0');
    final mes = dataSelecionada.month.toString().padLeft(2, '0');
    dataController.text = '$dia/$mes/${dataSelecionada.year}';
  }

  Future<void> escolherData() async {
    final ano = DateTime.now().year;
    final anoOriginal = widget.atendimentoInicial?.dataHora.year ?? ano;
    final primeiraData = DateTime(anoOriginal < ano ? anoOriginal : ano);
    final ultimaData = DateTime(ano + 100, 12, 31);
    var inicial = dataSelecionada;
    if (inicial.isBefore(primeiraData)) inicial = primeiraData;
    if (inicial.isAfter(ultimaData)) inicial = ultimaData;

    final data = await showDatePicker(
      context: context,
      initialDate: inicial,
      firstDate: primeiraData,
      lastDate: ultimaData,
      helpText: 'Selecione a data',
      cancelText: 'Cancelar',
      confirmText: 'Selecionar',
    );

    if (!mounted || data == null) return;
    dataSelecionada = DateUtils.dateOnly(data);
    atualizarTextoData();
  }

  Future<void> escolherHorario() async {
    final horario = await showTimePicker(
      context: context,
      initialTime: horarioSelecionado ?? TimeOfDay.now(),
      helpText: 'Selecione o horário',
      cancelText: 'Cancelar',
      confirmText: 'Selecionar',
      hourLabelText: 'Hora',
      minuteLabelText: 'Minuto',
    );

    if (!mounted || horario == null) return;
    horarioSelecionado = horario;
    final hora = horario.hour.toString().padLeft(2, '0');
    final minuto = horario.minute.toString().padLeft(2, '0');
    horarioController.text = '$hora:$minuto';
  }

  void salvar() {
    if (!chaveFormulario.currentState!.validate()) return;
    final horario = horarioSelecionado!;

    Navigator.pop(context, NovoAgendamento(
      pacienteId: pacienteId!,
      clinicaId: clinicaId == 0 ? null : clinicaId,
      dataHora: DateTime(
        dataSelecionada.year, dataSelecionada.month, dataSelecionada.day,
        horario.hour, horario.minute,
      ),
      duracaoMinutos: int.parse(duracaoController.text),
      emitirNotaFiscal: emitirNotaFiscal!,
      sala: clinicaId == 0 ? '' : salaController.text.trim(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final editando = widget.atendimentoInicial != null;
    return ModalFormulario(
      titulo: editando ? 'Editar agendamento' : 'Nova consulta',
      conteudo: formulario(),
      rodape: SizedBox(
        height: 50,
        child: Button(
          editando ? 'Salvar alterações' : 'Agendar consulta',
          onPressed: salvar,
        ),
      ),
    );
  }

  Widget formulario() {
    return Form(
      key: chaveFormulario,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: CamposAgendamento(
        pacientes: widget.pacientes,
        clinicas: widget.clinicas,
        pacienteId: pacienteId,
        clinicaId: clinicaId,
        emitirNotaFiscal: emitirNotaFiscal,
        dataController: dataController,
        horarioController: horarioController,
        duracaoController: duracaoController,
        salaController: salaController,
        aoSelecionarPaciente: (id) => setState(() => pacienteId = id),
        aoSelecionarClinica: (id) => setState(() => clinicaId = id),
        aoSelecionarNotaFiscal: (valor) =>
            setState(() => emitirNotaFiscal = valor),
        escolherData: escolherData,
        escolherHorario: escolherHorario,
      ),
    );
  }
}
