import 'package:flutter/material.dart';
import 'clinica.dart';
import 'package:pex/repositorios/clinicas_repositorio.dart';
import 'package:pex/shared/estilo/estilo_texto.dart';
import 'cabecalho_clinicas.dart';
import 'card_clinica.dart';
import 'formulario_clinica/modal_clinica.dart';
import 'perfil_clinica/modal_perfil_clinica.dart';

class Clinicas extends StatefulWidget {
  const Clinicas({
    super.key,
    this.aoAdicionar,
    this.aoAbrirClinica,
  });

  final VoidCallback? aoAdicionar;
  final ValueChanged<Clinica>? aoAbrirClinica;

  @override
  State<Clinicas> createState() => _ClinicasState();
}

class _ClinicasState extends State<Clinicas> {
  String busca = '';
  bool cadastroAberto = false;
  bool detalhesAbertos = false;
  late final streamClinicas = observarClinicas();

  void buscarClinica(String texto) {
    setState(() => busca = texto);
  }

  List<Clinica> filtrarClinicas(List<Clinica> todas) {
    final texto = busca.trim().toLowerCase();

    return todas.where((clinica) {
      return clinica.nome.toLowerCase().contains(texto) ||
          clinica.endereco.toLowerCase().contains(texto);
    }).toList();
  }

  Future<void> cadastrarClinica() async {
    if (widget.aoAdicionar != null) {
      widget.aoAdicionar!();
      return;
    }
    if (cadastroAberto) return;
    cadastroAberto = true;

    try {
      final nova = await abrirModalClinica(context);
      if (!mounted || nova == null) return;
      await adicionarClinica(nova);
    } finally {
      cadastroAberto = false;
    }
  }

  Future<void> abrirClinica(Clinica clinica) async {
    if (widget.aoAbrirClinica != null) {
      widget.aoAbrirClinica!(clinica);
      return;
    }
    if (detalhesAbertos) return;
    detalhesAbertos = true;

    try {
      await abrirModalPerfilClinica(context, clinica: clinica);
    } finally {
      detalhesAbertos = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CabecalhoClinicas(
          aoBuscar: buscarClinica,
          aoAdicionar: cadastrarClinica,
        ),
        const Divider(height: 1, color: Color(0xFFEAEAEA)),
        Expanded(
          child: StreamBuilder<List<Clinica>>(
            stream: streamClinicas,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Center(
                  child: Text('Não foi possível carregar as clínicas.'),
                );
              }
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              return conteudo(filtrarClinicas(snapshot.data!));
            },
          ),
        ),
      ],
    );
  }

  Widget conteudo(List<Clinica> clinicas) {
    final rotulo = clinicas.length == 1 ? 'clínica' : 'clínicas';
    return ColoredBox(
      color: const Color(0xFFF8F9FE),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 16, 22, 16),
            child: TextoComEstilo(
              '${clinicas.length} $rotulo',
              cor: Colors.grey,
              tamanho: 15,
            ),
          ),
          Expanded(child: listaClinicas(clinicas)),
        ],
      ),
    );
  }

  Widget listaClinicas(List<Clinica> clinicas) {
    if (clinicas.isEmpty) {
      return const Center(child: Text('Nenhuma clínica encontrada.'));
    }
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(22, 2, 22, 24),
      itemCount: clinicas.length,
      separatorBuilder: (context, indice) => const SizedBox(height: 18),
      itemBuilder: (context, indice) {
        final clinica = clinicas[indice];
        return CardClinica(
          clinica: clinica,
          aoClicar: () => abrirClinica(clinica),
        );
      },
    );
  }
}
