import 'package:flutter/material.dart';
import 'barra_navegacao.dart';
import 'conteudo_inicio/conteudo_inicio.dart';
import 'agenda/agenda.dart';
import 'pacientes/pacientes.dart';
import 'clinicas/clinicas.dart';
import 'opcoes/opcoes.dart';

class Inicio extends StatefulWidget {
  const Inicio({super.key});

  @override
  State<Inicio> createState() => _InicioState();
}

class _InicioState extends State<Inicio> {
  int indiceAtual = 0;

  void trocarPagina(int indice) {
    setState(() {
      indiceAtual = indice;
    });
  }

  Widget paginaAtual() {
    if (indiceAtual == 0) {
      return ConteudoInicio();
    }
    else if (indiceAtual == 1){
      return Agenda();
    }
    else if (indiceAtual == 2){
      return const Pacientes();
    }
    else if (indiceAtual == 3){
      return const Clinicas();
    }
    else if (indiceAtual == 4){
      return const Opcoes();
    }

    return const Center(
      child: Text('Página em construção'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: paginaAtual(),
      ),
      bottomNavigationBar: BarraNavegacao(
        indiceAtual: indiceAtual,
        aoSelecionar: trocarPagina,
      ),
    );
  }
}
