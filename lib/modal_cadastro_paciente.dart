import 'package:flutter/material.dart';
import 'package:drift/drift.dart' as drift;
import '../database/app_database.dart';

void mostrarModalCadastroPaciente(BuildContext context, AppDatabase db, int medicoIdLogado) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true, 
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) => Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: ModalCadastroPaciente(db: db, medicoId: medicoIdLogado),
    ),
  );
}

class ModalCadastroPaciente extends StatefulWidget {
  final AppDatabase db;
  final int medicoId;

  const ModalCadastroPaciente({Key? key, required this.db, required this.medicoId}) : super(key: key);

  @override
  State<ModalCadastroPaciente> createState() => _ModalCadastroPacienteState();
}

class _ModalCadastroPacienteState extends State<ModalCadastroPaciente> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _cpfController = TextEditingController();
  final _telefoneController = TextEditingController();
  DateTime _dataNascimentoSelecionada = DateTime.now();

  @override
  void dispose() {
    _nomeController.dispose();
    _cpfController.dispose();
    _telefoneController.dispose();
    super.dispose();
  }

  Future<void> _salvarPaciente() async {
    if (_formKey.currentState!.validate()) {
      final novoPaciente = PacientesCompanion(
        medicoId: drift.Value(widget.medicoId),
        nomeCompleto: drift.Value(_nomeController.text),
        cpf: drift.Value(_cpfController.text),
        telefone: drift.Value(_telefoneController.text),
        dataNascimento: drift.Value(_dataNascimentoSelecionada),
        email: const drift.Value(''), 
        endereco: const drift.Value(''),
      );

      await widget.db.inserirPaciente(novoPaciente);

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Paciente cadastrado com sucesso!')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min, 
          children: [
            const Text('Novo Paciente', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nomeController,
              decoration: const InputDecoration(labelText: 'Nome Completo', border: OutlineInputBorder()),
              validator: (value) => value == null || value.isEmpty ? 'Informe o nome' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _cpfController,
              decoration: const InputDecoration(labelText: 'CPF', border: OutlineInputBorder()),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _telefoneController,
              decoration: const InputDecoration(labelText: 'Telefone', border: OutlineInputBorder()),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _salvarPaciente,
                child: const Text('Cadastrar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}