import 'package:flutter/material.dart';
import '../../shared/estilo/estilo_texto.dart';
import 'package:pex/shared/atendimento/atendimento.dart';
import 'package:pex/shared/atendimento/modal_atendimento.dart';
import 'package:pex/repositorios/agendamentos_repositorio.dart';
import 'package:pex/repositorios/clinicas_repositorio.dart';
import 'package:pex/repositorios/pacientes_repositorio.dart';
import 'card_atendimento.dart';
import 'seletor_dias.dart';
import './formulario_agenda/modal_agendamento.dart';

class Agenda extends StatefulWidget {
  const Agenda({super.key});

  @override
  State<Agenda> createState() => _AgendaState();
}

class _AgendaState extends State<Agenda> {
  DateTime dataSelecionada = DateUtils.dateOnly(DateTime.now());
  late Stream<List<Atendimento>> streamAtendimentos;

  @override
  void initState() {
    super.initState();
    streamAtendimentos = observarAtendimentosDoDia(dataSelecionada);
  }

  void selecionarData(DateTime data) {
    setState(() {
      dataSelecionada = DateUtils.dateOnly(data);
      streamAtendimentos = observarAtendimentosDoDia(dataSelecionada);
    });
  }

  Future<void> agendarConsulta() async {
    final pacientes = {
      for (final paciente in await listarPacientes()) paciente.id: paciente.nome,
    };
    final clinicas = {
      for (final clinica in await listarClinicas()) clinica.id: clinica.nome,
    };
    if (!mounted) return;
    if (pacientes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cadastre um paciente antes de agendar.')),
      );
      return;
    }

    final consulta = await abrirModalAgendamento(
      context,
      dataInicial: dataSelecionada,
      pacientes: pacientes,
      clinicas: clinicas,
    );

    if (!mounted || consulta == null) return;

    await adicionarAtendimento(consulta);
    if (!mounted) return;

    selecionarData(consulta.dataHora);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Consulta agendada')),
    );
  }

  void abrirAtendimento(Atendimento atendimento) {
    abrirModalAtendimento(context, atendimento: atendimento);
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: const Color(0xFFF8F9FD),
      child: Column(
        children: [
          cabecalho(),
          const Divider(height: 1, color: Color(0xFFEAEAEA)),
          Expanded(child: listaAtendimentos()),
        ],
      ),
    );
  }

  Widget cabecalho() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(24, 22, 24, 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const TextoComEstilo(
                'Agenda',
                cor: Color(0xFF29363D),
                tamanho: 24,
                peso: FontWeight.bold,
              ),
              IconButton.filled(
                onPressed: agendarConsulta,
                tooltip: 'Adicionar atendimento',
                style: IconButton.styleFrom(
                  backgroundColor: const Color(0xFF328783),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.add, size: 30),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SeletorDias(
            dataSelecionada: dataSelecionada,
            aoSelecionar: selecionarData,
          ),
        ],
      ),
    );
  }

  Widget listaAtendimentos() {
    return StreamBuilder<List<Atendimento>>(
      key: ValueKey(dataSelecionada),
      stream: streamAtendimentos,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text('Erro ao carregar os atendimentos'));
        }

        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final atendimentos = snapshot.data!;

        if (atendimentos.isEmpty) {
          return const Center(child: Text('Nenhum atendimento neste dia'));
        }

        return ListView.separated(
          padding: const EdgeInsets.fromLTRB(24, 30, 24, 24),
          itemCount: atendimentos.length,
          separatorBuilder: (context, indice) => const SizedBox(height: 22),
          itemBuilder: (context, indice) {
            final atendimento = atendimentos[indice];

            return CardAtendimento(
              atendimento: atendimento,
              onTap: () => abrirAtendimento(atendimento),
            );
          },
        );
      },
    );
  }
}
