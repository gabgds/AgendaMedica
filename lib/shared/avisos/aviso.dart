import 'dart:async';

import 'package:flutter/material.dart';

/// Exibe o aviso no topo, sobre as páginas, bottom sheets e diálogos.
void mostrarAviso(BuildContext context, String mensagem) {
  final camada = context.findAncestorStateOfType<_CamadaAvisosState>();
  assert(camada != null, 'Adicione CamadaAvisos ao builder do MaterialApp.');
  camada?.mostrar(mensagem);
}

class CamadaAvisos extends StatefulWidget {
  const CamadaAvisos({super.key, required this.child});

  final Widget child;

  @override
  State<CamadaAvisos> createState() => _CamadaAvisosState();
}

class _CamadaAvisosState extends State<CamadaAvisos> {
  String? mensagem;
  Timer? temporizador;

  void mostrar(String texto) {
    temporizador?.cancel();
    setState(() => mensagem = texto);
    temporizador = Timer(const Duration(seconds: 4), fechar);
  }

  void fechar() {
    temporizador?.cancel();
    if (mounted) setState(() => mensagem = null);
  }

  @override
  void dispose() {
    temporizador?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        widget.child,
        if (mensagem != null)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              bottom: false,
              minimum: const EdgeInsets.all(12),
              child: Align(
                alignment: Alignment.topCenter,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 600),
                  child: Semantics(
                    container: true,
                    liveRegion: true,
                    child: Material(
                      color: const Color(0xFF323232),
                      elevation: 6,
                      borderRadius: BorderRadius.circular(8),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16, right: 4),
                        child: Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                                child: Text(
                                  mensagem!,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: fechar,
                              color: Colors.white,
                              icon: const Icon(
                                Icons.close,
                                semanticLabel: 'Fechar aviso',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
