import 'package:flutter/material.dart';
import 'paginas/inicio.dart';
import 'paginas/login.dart';
import 'shared/usuario/sessao.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await restaurarSessao();
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
      routes: {
        '/login': (context) => const TelaInicial(),
      },
      home: medicoLogado == null ? const TelaInicial() : const Inicio(),
    );
  }
}

class TelaInicial extends StatelessWidget {
  const TelaInicial({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Login(),
      ),
    );
  }
}
