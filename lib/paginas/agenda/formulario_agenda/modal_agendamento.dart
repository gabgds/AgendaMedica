import 'package:flutter/material.dart';
import '../../../shared/botões/botao_verde.dart';
import '../../../shared/formulario/modal_formulario.dart';
import 'campos_agendamento.dart';
import 'novo_agendamento.dart';

// Abre o formulário como modal e devolve os dados ao clicar em Agendar.
// Ao fechar com a seta, arrastar ou tocar fora, o resultado é null.
Future<NovoAgendamento?> abrirModalAgendamento(
  BuildContext context, {
  required DateTime dataInicial,
  required Map<int, String> pacientes,
  required Map<int, String> clinicas,
}) {
  return abrirModalFormulario<NovoAgendamento>(
    context,
    builder: (context) => ModalAgendamento(
      dataInicial: dataInicial,
      pacientes: pacientes,
      clinicas: clinicas,
    ),
  );
}

class ModalAgendamento extends StatefulWidget {
  const ModalAgendamento({
    super.key,
    required this.dataInicial,
    required this.pacientes,
    required this.clinicas,
  });

  final DateTime dataInicial;
  final Map<int, String> pacientes;
  final Map<int, String> clinicas;

  @override
  State<ModalAgendamento> createState() => _ModalAgendamentoState();
}

class _ModalAgendamentoState extends State<ModalAgendamento> {
  final chaveFormulario = GlobalKey<FormState>();
  final dataController = TextEditingController();
  final horarioController = TextEditingController();
  final duracaoController = TextEditingController();

  int? pacienteId;
  int? clinicaId;
  late DateTime dataSelecionada;
  TimeOfDay? horarioSelecionado;

  @override
  void initState() {
    super.initState();
    dataSelecionada = DateUtils.dateOnly(widget.dataInicial);
    atualizarTextoData();
  }

  @override
  void dispose() {
    dataController.dispose();
    horarioController.dispose();
    duracaoController.dispose();
    super.dispose();
  }

  void atualizarTextoData() {
    final dia = dataSelecionada.day.toString().padLeft(2, '0');
    final mes = dataSelecionada.month.toString().padLeft(2, '0');
    dataController.text = '$dia/$mes/${dataSelecionada.year}';
  }

  Future<void> escolherData() async {
    final ano = DateTime.now().year;
    final primeiraData = DateTime(ano);
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

  void agendar() {
    if (!chaveFormulario.currentState!.validate()) return;
    final horario = horarioSelecionado!;

    Navigator.pop(context, NovoAgendamento(
      pacienteId: pacienteId!,
      // Converte a opção Avulso do seletor em ausência de vínculo com clínica.
      clinicaId: clinicaId == 0 ? null : clinicaId,
      dataHora: DateTime(
        dataSelecionada.year, dataSelecionada.month, dataSelecionada.day,
        horario.hour, horario.minute,
      ),
      duracaoMinutos: int.parse(duracaoController.text),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return ModalFormulario(
      // Mantém o formulário e o botão acima do teclado.
      titulo: 'Nova consulta',
      conteudo: formulario(),
      rodape: SizedBox(
        height: 50,
        child: GreenButton('Agendar consulta', onPressed: agendar),
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
        dataController: dataController,
        horarioController: horarioController,
        duracaoController: duracaoController,
        aoSelecionarPaciente: (id) => setState(() => pacienteId = id),
        aoSelecionarClinica: (id) => setState(() => clinicaId = id),
        escolherData: escolherData,
        escolherHorario: escolherHorario,
      ),
    );
  }
}
