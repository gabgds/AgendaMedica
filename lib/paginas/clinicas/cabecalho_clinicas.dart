import 'package:flutter/material.dart';
import 'package:pex/shared/listagem/cabecalho_listagem.dart';

class CabecalhoClinicas extends StatelessWidget {
  const CabecalhoClinicas({
    super.key,
    required this.aoBuscar,
    this.aoAdicionar,
  });

  final ValueChanged<String> aoBuscar;
  final VoidCallback? aoAdicionar;

  @override
  Widget build(BuildContext context) {
    return CabecalhoListagem(
      titulo: 'Clínicas',
      tamanhoTitulo: 24,
      textoBusca: 'Buscar clínica...',
      textoBotao: '+ Adicionar',
      larguraBotao: 132,
      alturaBotao: 40,
      tamanhoTextoBotao: 16,
      aoBuscar: aoBuscar,
      aoAdicionar: aoAdicionar,
    );
  }
}
