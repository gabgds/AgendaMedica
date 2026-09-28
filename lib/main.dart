import 'package:flutter/material.dart';
import 'package:pex/modal_cadastro_paciente.dart';
import 'database/app_database.dart';
import 'login.dart';

void main() {
  runApp(const MinhaAgendaApp());
}

class MinhaAgendaApp extends StatelessWidget {
  const MinhaAgendaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
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
      body: const Center(
        child: Login(),
      ),
    );
  }
}