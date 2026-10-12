import 'package:flutter/material.dart';
import 'package:pex/shared/estilo/estilo_texto.dart';
import 'package:pex/shared/paciente/paciente.dart';
import 'cabecalho_pacientes.dart';
import 'card_paciente.dart';
import 'dados_pacientes_teste.dart';

// Conteúdo da aba Pacientes. O Scaffold e a navegação ficam em Inicio.
class Pacientes extends StatefulWidget {
  const Pacientes({
    super.key,
    this.pacientes = pacientesTeste,
    this.aoAdicionar,
    this.aoAbrirPaciente,
  });

  final List<Paciente> pacientes;
  final VoidCallback? aoAdicionar;
  final ValueChanged<Paciente>? aoAbrirPaciente;

  @override
  State<Pacientes> createState() => _PacientesState();
}

class _PacientesState extends State<Pacientes> {
  String busca = '';

  void buscarPaciente(String texto) {
    setState(() => busca = texto);
  }

  List<Paciente> filtrarPacientes() {
    final texto = busca.trim().toLowerCase();

    return widget.pacientes.where((paciente) {
      return paciente.nome.toLowerCase().contains(texto) ||
          paciente.telefone.contains(texto);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final pacientes = filtrarPacientes();

    return Column(
      children: [
        CabecalhoPacientes(
          aoBuscar: buscarPaciente,
          aoAdicionar: widget.aoAdicionar,
        ),
        const Divider(height: 1, color: Color(0xFFEAEAEA)),
        Expanded(child: conteudo(pacientes)),
      ],
    );
  }

  Widget conteudo(List<Paciente> pacientes) {
    final rotulo = pacientes.length == 1 ? 'paciente' : 'pacientes';

    return ColoredBox(
      color: const Color(0xFFF8F9FE),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 16, 22, 16),
            child: TextoComEstilo(
              '${pacientes.length} $rotulo',
              cor: Colors.grey,
              tamanho: 15,
            ),
          ),
          Expanded(child: listaPacientes(pacientes)),
        ],
      ),
    );
  }

  Widget listaPacientes(List<Paciente> pacientes) {
    if (pacientes.isEmpty) {
      return const Center(child: Text('Nenhum paciente encontrado.'));
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(22, 2, 22, 24),
      itemCount: pacientes.length,
      separatorBuilder: (context, indice) => const SizedBox(height: 18),
      itemBuilder: (context, indice) => criarCard(pacientes[indice]),
    );
  }

  Widget criarCard(Paciente paciente) {
    return CardPaciente(
      paciente: paciente,
      aoClicar: widget.aoAbrirPaciente == null
          ? null
          : () => widget.aoAbrirPaciente!(paciente),
    );
  }
}
