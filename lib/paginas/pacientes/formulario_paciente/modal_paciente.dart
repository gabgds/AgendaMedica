import 'package:flutter/material.dart';
import 'package:pex/shared/botões/botao.dart';
import 'package:pex/shared/formulario/modal_formulario.dart';
import 'package:pex/shared/paciente/paciente.dart';
import 'campos_paciente.dart';
import 'novo_paciente.dart';

Future<NovoPaciente?> abrirModalPaciente(
  BuildContext context, {
  required Map<int, String> clinicas,
  Paciente? pacienteInicial,
}) {
  return abrirModalFormulario<NovoPaciente>(
    context,
    builder: (context) => ModalPaciente(
      clinicas: clinicas,
      pacienteInicial: pacienteInicial,
    ),
  );
}

class ModalPaciente extends StatefulWidget {
  const ModalPaciente({
    super.key,
    required this.clinicas,
    this.pacienteInicial,
  });

  final Map<int, String> clinicas;
  final Paciente? pacienteInicial;

  @override
  State<ModalPaciente> createState() => _ModalPacienteState();
}

class _ModalPacienteState extends State<ModalPaciente> {
  final chaveFormulario = GlobalKey<FormState>();
  final nomeController = TextEditingController();
  final dataController = TextEditingController();
  final cpfController = TextEditingController();
  final enderecoController = TextEditingController();
  final emailController = TextEditingController();
  final telefoneController = TextEditingController();

  DateTime? dataNascimento;
  bool? emitirNotaFiscal;
  int? clinicaId;
  bool escolhendoData = false;

  @override
  void initState() {
    super.initState();
    final paciente = widget.pacienteInicial;
    if (paciente == null) return;

    nomeController.text = paciente.nome;
    cpfController.text = paciente.cpf.replaceAll(RegExp(r'\D'), '');
    enderecoController.text = paciente.endereco;
    emailController.text = paciente.email;
    telefoneController.text = paciente.telefone.replaceAll(RegExp(r'\D'), '');
    emitirNotaFiscal = paciente.emitirNotaFiscal;
    clinicaId = paciente.clinicaId ?? 0;
    dataNascimento = paciente.dataNascimento;
    atualizarTextoData();
  }

  void atualizarTextoData() {
    final data = dataNascimento;
    if (data == null) return;
    final dia = data.day.toString().padLeft(2, '0');
    final mes = data.month.toString().padLeft(2, '0');
    dataController.text = '$dia/$mes/${data.year}';
  }

  @override
  void dispose() {
    nomeController.dispose();
    dataController.dispose();
    cpfController.dispose();
    enderecoController.dispose();
    emailController.dispose();
    telefoneController.dispose();
    super.dispose();
  }

  Future<void> escolherData() async {
    if (escolhendoData) return;
    escolhendoData = true;
    FocusScope.of(context).unfocus();

    try {
      final hoje = DateUtils.dateOnly(DateTime.now());
      final primeiraData = DateTime(1900);
      var inicial = dataNascimento ?? hoje;
      if (inicial.isBefore(primeiraData)) inicial = primeiraData;
      if (inicial.isAfter(hoje)) inicial = hoje;
      final data = await showDatePicker(
        context: context,
        initialDate: inicial,
        firstDate: primeiraData,
        lastDate: hoje,
        initialDatePickerMode: DatePickerMode.year,
        helpText: 'Selecione a data de nascimento',
        cancelText: 'Cancelar',
        confirmText: 'Selecionar',
      );

      if (!mounted || data == null) return;
      dataNascimento = DateUtils.dateOnly(data);
      atualizarTextoData();
    } finally {
      escolhendoData = false;
    }
  }

  void salvar() {
    if (!chaveFormulario.currentState!.validate()) return;
    FocusScope.of(context).unfocus();

    Navigator.pop(
      context,
      NovoPaciente(
        nome: nomeController.text.trim(),
        dataNascimento: dataNascimento!,
        cpf: cpfController.text.trim(),
        endereco: enderecoController.text.trim(),
        email: emailController.text.trim(),
        telefone: telefoneController.text.trim(),
        emitirNotaFiscal: emitirNotaFiscal!,
        clinicaId: clinicaId == 0 ? null : clinicaId,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final editando = widget.pacienteInicial != null;
    final clinicas = <int, String>{...widget.clinicas};
    final clinicaInicial = widget.pacienteInicial?.clinicaId;
    if (clinicaInicial != null) {
      // Preserva vínculos existentes mesmo se a clínica não veio nas opções.
      clinicas.putIfAbsent(clinicaInicial, () => 'Clínica $clinicaInicial');
    }

    return ModalFormulario(
      titulo: editando ? 'Editar paciente' : 'Novo paciente',
      conteudo: Form(
        key: chaveFormulario,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: CamposPaciente(
          nomeController: nomeController,
          dataController: dataController,
          cpfController: cpfController,
          enderecoController: enderecoController,
          emailController: emailController,
          telefoneController: telefoneController,
          clinicas: clinicas,
          clinicaId: clinicaId,
          emitirNotaFiscal: emitirNotaFiscal,
          escolherData: escolherData,
          aoSelecionarClinica: (id) => setState(() => clinicaId = id),
          aoSelecionarNotaFiscal: (valor) =>
              setState(() => emitirNotaFiscal = valor),
        ),
      ),
      rodape: SizedBox(
        height: 50,
        child: Button(
          editando ? 'Salvar alterações' : 'Cadastrar paciente',
          cor: const Color(0xFF009691),
          padding: EdgeInsets.zero,
          onPressed: salvar,
        ),
      ),
    );
  }
}
