import 'package:flutter/material.dart';
import 'shared/navegacao/barra_navegacao.dart';
import 'paginas/conteudo_inicio/conteudo_inicio.dart';

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