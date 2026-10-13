import 'package:flutter/material.dart';
import 'package:pex/shared/clinica/clinica.dart';
import 'package:pex/shared/clinica/dados_clinicas_em_memoria.dart';
import 'package:pex/shared/estilo/estilo_texto.dart';
import 'cabecalho_clinicas.dart';
import 'card_clinica.dart';
import 'dados_clinicas_teste.dart';
import 'formulario_clinica/modal_clinica.dart';
import 'perfil_clinica/modal_perfil_clinica.dart';

// Conteúdo da aba: o Scaffold e a barra de navegação ficam em Inicio.
class Clinicas extends StatefulWidget {
  const Clinicas({
    super.key,
    this.clinicas = clinicasTeste,
    this.aoAdicionar,
    this.aoAbrirClinica,
  });

  final List<Clinica> clinicas;
  final VoidCallback? aoAdicionar;
  final ValueChanged<Clinica>? aoAbrirClinica;

  @override
  State<Clinicas> createState() => _ClinicasState();
}

class _ClinicasState extends State<Clinicas> {
  String busca = '';
  bool cadastroAberto = false;
  bool detalhesAbertos = false;

  void buscarClinica(String texto) {
    setState(() => busca = texto);
  }

  List<Clinica> filtrarClinicas() {
    final texto = busca.trim().toLowerCase();
    final numeros = texto.replaceAll(RegExp(r'\D'), '');
    final buscaTelefone = numeros.isNotEmpty &&
        RegExp(r'^[0-9()\s.+-]+$').hasMatch(texto);

    return clinicasEmMemoria(widget.clinicas).where((clinica) {
      return clinica.nome.toLowerCase().contains(texto) ||
          clinica.endereco.toLowerCase().contains(texto) ||
          clinica.telefone.contains(texto) ||
          (buscaTelefone &&
              clinica.telefone.replaceAll(RegExp(r'\D'), '').contains(numeros));
    }).toList();
  }

  Future<void> adicionarClinica() async {
    if (widget.aoAdicionar != null) {
      widget.aoAdicionar!();
      return;
    }
    if (cadastroAberto) return;
    cadastroAberto = true;

    try {
      final nova = await abrirModalClinica(context);
      if (!mounted || nova == null) return;
      final clinica = nova.paraClinica(
        id: proximoIdClinicaEmMemoria(widget.clinicas),
      );
      setState(() => adicionarClinicaEmMemoria(clinica));
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
      if (!mounted) return;
      // Atualiza os cards, o contador e a pesquisa após editar ou remover.
      setState(() {});
    } finally {
      detalhesAbertos = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final clinicas = filtrarClinicas();
    return Column(
      children: [
        CabecalhoClinicas(
          aoBuscar: buscarClinica,
          aoAdicionar: adicionarClinica,
        ),
        const Divider(height: 1, color: Color(0xFFEAEAEA)),
        Expanded(child: conteudo(clinicas)),
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
