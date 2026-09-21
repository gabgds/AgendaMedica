import 'package:flutter/material.dart';
import 'package:pex/modal_cadastro_paciente.dart';
import 'database/app_database.dart';

void main() {
  runApp(const MinhaAgendaApp());
}

class MinhaAgendaApp extends StatelessWidget {
  const MinhaAgendaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Agenda Médica',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: const TelaInicial(),
    );
  }
}

class TelaInicial extends StatefulWidget {
  const TelaInicial({super.key});

  @override
  State<TelaInicial> createState() => _TelaInicialState();
}

class _TelaInicialState extends State<TelaInicial> {
  late AppDatabase database;

  @override
  void initState() {
    super.initState();
    database = AppDatabase();
  }

  @override
  void dispose() {
    database.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agenda Médica'),
        backgroundColor: const Color(0xFF0D6E63),
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text('Nenhum paciente cadastrado ainda.'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          mostrarModalCadastroPaciente(context, database, 1);
        },
        backgroundColor: const Color(0xFF358C80), 
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}