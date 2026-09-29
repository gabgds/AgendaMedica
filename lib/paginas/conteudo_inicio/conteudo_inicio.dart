import 'package:flutter/material.dart';
import '../../shared/funcoes/data_atual.dart';
import 'card_agenda.dart';
import 'contador_resumo.dart';
import 'card_proximo_atendimento.dart';
import 'dados_para_teste.dart';

class ConteudoInicio extends StatefulWidget {
  const ConteudoInicio({super.key});

  @override
  State<ConteudoInicio> createState() => _ConteudoInicioState();
}

class _ConteudoInicioState extends State<ConteudoInicio> {
  static const ciano_claro = Color(0xFF00D6D0);
  static const ciano_escuro = Color(0xFF00635F);
  static const laranja = Color(0xFFFF914D);

  // essas três variáveis stream vem do dados_para_teste.dart
  late final streamContadores = criarStreamContadores();

  late final streamProximoAtendimento =
  criarStreamProximoAtendimento();


  late final streamAgenda = Stream<List<Widget>>.value(
    atendimentosHoje(),
    // cria uma lista de atendimentos
    // [
    // ItemAtendimento(...),
    // ItemAtendimento(...),
    // ]
  );

  // Os snapshots são as informações mais recentes nas variáveis stream

  // Esse primeiro Widget junta tudo, a página do início é formado por:
  // resumo() - parte com fundo verde, que mostra o dia atual e os contadores
  // proximoAtendimento() - Card que sobrepõe o resumo()
  // agendaHoje() - Card que mostra os agendamentos de hoje, se tiver algum
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Stack(
            children: [
              Positioned.fill(
                bottom: 100,
                child: Container(
                  color: ciano_escuro,
                ),
              ),
              Column(
                children: [
                  resumo(),
                  proximoAtendimento(),
                ],
              ),
            ],
          ),
          agendaHoje(),
        ],
      ),
    );
  }

  // Dia atual e contadores
  Widget resumo() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      color: ciano_escuro,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            dataAtual(),
            style: const TextStyle(
              color: ciano_claro,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 32),
          cardsResumo(),
        ],
      ),
    );
  }

  // Quantidade de atendimentos de hoje, concluídos e restantes, dentro dos retângulos
  Widget cardsResumo() {
    return StreamBuilder<Map<String, int>>(
      stream: streamContadores,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('Erro ao carregar os contadores');
        }

        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final dados = snapshot.data!;
        final hoje = dados['hoje']!;
        final concluidos = dados['concluidos']!;
        final restantes = hoje - concluidos;

        return Row(
          children: [
            Expanded(
              child: ContadorResumo(
                titulo: 'Hoje',
                quantidade: hoje,
                cor: Colors.white,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: ContadorResumo(
                titulo: 'Concluídos',
                quantidade: concluidos,
                cor: ciano_claro,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: ContadorResumo(
                titulo: 'Restantes',
                quantidade: restantes,
                cor: laranja,
              ),
            ),
          ],
        );
      },
    );
  }

  // Card que mostra o próximo atendimento
  Widget proximoAtendimento() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      child: StreamBuilder<Map<String, String>?>(
        stream: streamProximoAtendimento,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text('Erro ao carregar o próximo atendimento');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final atendimento = snapshot.data;

          if (atendimento == null) {
            return const SizedBox.shrink();
          }

          return CardProximoAtendimento(
            horario: atendimento['horario']!,
            paciente: atendimento['paciente']!,
            local: atendimento['local']!,
            descricao: atendimento['descricao']!,
            onTap: () {},
          );
        },
      ),
    );
  }

  // Lista dos atendimentos do dia
  Widget agendaHoje() {
    return StreamBuilder<List<Widget>>(
      stream: streamAgenda,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('Erro ao carregar os atendimentos');
        }

        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final atendimentos = snapshot.data!;

        if (atendimentos.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(24),
            child: Center(
              child: Text('Nenhum atendimento hoje'),
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
          child: CardAgenda(
            data: dataAtual(),
            atendimentos: snapshot.data!,
          ),
        );
      },
    );
  }
}