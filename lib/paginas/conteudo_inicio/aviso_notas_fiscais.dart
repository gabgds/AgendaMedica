import 'package:flutter/material.dart';
import 'package:pex/shared/atendimento/atendimento.dart';
import 'package:pex/repositorios/agendamentos_repositorio.dart';
import 'package:pex/shared/atendimento/modal_notas_fiscais.dart';
import 'package:pex/shared/listagem/card_listagem.dart';

class AvisoNotasFiscais extends StatefulWidget {
  const AvisoNotasFiscais({super.key});

  @override
  State<AvisoNotasFiscais> createState() => _AvisoNotasFiscaisState();
}

class _AvisoNotasFiscaisState extends State<AvisoNotasFiscais> {
  late final streamPendencias = observarNotasFiscais(apenasPendentes: true);
  bool modalAberto = false;

  Future<void> abrirPendencias() async {
    if (modalAberto) return;
    modalAberto = true;
    try {
      await abrirModalNotasFiscais(context, apenasPendentes: true);
    } finally {
      modalAberto = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Atendimento>>(
      stream: streamPendencias,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Padding(
            padding: EdgeInsets.all(24),
            child: Text('Não foi possível carregar as pendências de notas.'),
          );
        }
        final quantidade = snapshot.data?.length ?? 0;
        if (quantidade == 0) return const SizedBox.shrink();

        return Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
          child: CardListagem(
            aoClicar: abrirPendencias,
            conteudo: Row(
              children: [
                const Icon(Icons.receipt_long_outlined, color: Color(0xFFB25D15)),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        quantidade == 1
                            ? '1 nota fiscal pendente'
                            : '$quantidade notas fiscais pendentes',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      const Text('Toque para registrar a emissão.'),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right),
              ],
            ),
          ),
        );
      },
    );
  }
}
