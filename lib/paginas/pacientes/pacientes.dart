import 'package:flutter/material.dart';
import 'package:pex/shared/estilo/estilo_texto.dart';
import 'package:pex/repositorios/pacientes_repositorio.dart';
import 'paciente.dart';
import 'cabecalho_pacientes.dart';
import 'card_paciente.dart';
import 'formulario_paciente/modal_paciente.dart';
import 'perfil_paciente/modal_perfil_paciente.dart';

class Pacientes extends StatefulWidget {
  const Pacientes({
    super.key,
    this.aoAdicionar,
    this.aoAbrirPaciente,
    this.aoAbrirNotasFiscais,
  });

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
  late final streamPacientes = observarPacientes();

  Future<void> cadastrarPaciente() async {
    if (widget.aoAdicionar != null) {
      widget.aoAdicionar!();
      return;
    }
    if (cadastroAberto) return;
    cadastroAberto = true;

    try {
      final novo = await abrirModalPaciente(context);
      if (!mounted || novo == null) return;

      try {
        await adicionarPaciente(novo);
      } on CpfJaCadastrado catch (erro) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(erro.toString())),
        );
      }
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
    } finally {
      perfilAberto = false;
    }
  }

  void buscarPaciente(String texto) {
    setState(() => busca = texto);
  }

  List<Paciente> filtrarPacientes(List<Paciente> todos) {
    final texto = busca.trim().toLowerCase();

    return todos.where((paciente) {
      return paciente.nome.toLowerCase().contains(texto) ||
          paciente.telefone.contains(texto);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CabecalhoPacientes(
          aoBuscar: buscarPaciente,
          aoAdicionar: cadastrarPaciente,
        ),
        const Divider(height: 1, color: Color(0xFFEAEAEA)),
        Expanded(
          child: StreamBuilder<List<Paciente>>(
            stream: streamPacientes,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Center(
                  child: Text('Não foi possível carregar os pacientes.'),
                );
              }
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              return conteudo(filtrarPacientes(snapshot.data!));
            },
          ),
        ),
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
