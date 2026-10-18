import 'package:flutter/material.dart';
import 'package:pex/shared/estilo/estilo_texto.dart';
import 'paciente.dart';
import 'dados_pacientes_em_memoria.dart';
import 'cabecalho_pacientes.dart';
import 'card_paciente.dart';
import 'dados_pacientes_teste.dart';
import 'formulario_paciente/modal_paciente.dart';
import 'perfil_paciente/modal_perfil_paciente.dart';

class Pacientes extends StatefulWidget {
  const Pacientes({
    super.key,
    this.pacientes = pacientesTeste,
    this.aoAdicionar,
    this.aoAbrirPaciente,
    this.aoAbrirNotasFiscais,
  });

  final List<Paciente> pacientes;
  final VoidCallback? aoAdicionar;
  final ValueChanged<Paciente>? aoAbrirPaciente;
  final ValueChanged<Paciente>? aoAbrirNotasFiscais;

  @override
  State<Pacientes> createState() => _PacientesState();
}

class _PacientesState extends State<Pacientes> {
  String busca = '';
  bool cadastroAberto = false;
  bool perfilAberto = false;

  Future<void> adicionarPaciente() async {
    if (widget.aoAdicionar != null) {
      widget.aoAdicionar!();
      return;
    }
    if (cadastroAberto) return;
    cadastroAberto = true;

    try {
      final novo = await abrirModalPaciente(context);
      if (!mounted || novo == null) return;

      final paciente = novo.paraPaciente(
        id: proximoIdPacienteEmMemoria(widget.pacientes),
      );

      setState(() => adicionarPacienteEmMemoria(paciente));
    } finally {
      cadastroAberto = false;
    }
  }

  Future<void> abrirPaciente(Paciente paciente) async {
    if (widget.aoAbrirPaciente != null) {
      widget.aoAbrirPaciente!(paciente);
      return;
    }
    if (perfilAberto) return;
    perfilAberto = true;

    try {
      await abrirModalPerfilPaciente(
        context,
        paciente: paciente,
        aoAbrirNotasFiscais: widget.aoAbrirNotasFiscais,
      );
      if (!mounted) return;
      setState(() {});
    } finally {
      perfilAberto = false;
    }
  }

  void buscarPaciente(String texto) {
    setState(() => busca = texto);
  }

  List<Paciente> filtrarPacientes() {
    final texto = busca.trim().toLowerCase();

    return pacientesEmMemoria(widget.pacientes).where((paciente) {
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
          aoAdicionar: adicionarPaciente,
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
      aoClicar: () => abrirPaciente(paciente),
    );
  }
}
