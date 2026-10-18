import 'package:flutter/material.dart';
import 'package:pex/shared/listagem/cabecalho_listagem.dart';

class CabecalhoPacientes extends StatelessWidget {
  const CabecalhoPacientes({
    super.key,
    required this.aoBuscar,
    this.aoAdicionar,
  });

  final ValueChanged<String> aoBuscar;
  final VoidCallback? aoAdicionar;

  @override
  Widget build(BuildContext context) {
    return CabecalhoListagem(
      titulo: 'Pacientes',
      textoBusca: 'Buscar paciente...',
      aoBuscar: aoBuscar,
      aoAdicionar: aoAdicionar,
    );
  }
}
