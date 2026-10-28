import 'dart:async';

import 'package:flutter/material.dart';

Future<T?> abrirModalFormulario<T>(
  BuildContext context, {
  required WidgetBuilder builder,
}) {
  FocusManager.instance.primaryFocus?.unfocus();
  final fluxo = context.findAncestorStateOfType<_FluxoModalState>();
  if (fluxo != null) return fluxo.abrirPagina<T>(builder);

  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.white,
    clipBehavior: Clip.antiAlias,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (contextModal) => _FluxoModal(
      builder: builder,
      aoFechar: (resultado) {
        if (ModalRoute.of(contextModal)?.isCurrent ?? false) {
          Navigator.of(contextModal).pop<T>(resultado as T?);
        }
      },
    ),
  );
}

/// Volta à etapa anterior; na primeira etapa, fecha o painel com o resultado.
void fecharEtapaModal<T>(BuildContext context, [T? resultado]) {
  final fluxo = context.findAncestorStateOfType<_FluxoModalState>();
  if (fluxo?.fechando ?? false) return;
  if (fluxo != null && !fluxo.navegador.currentState!.canPop()) {
    fluxo.fechar(resultado);
  } else {
    Navigator.of(context).pop<T>(resultado);
  }
}

void fecharPainelModal(BuildContext context) {
  final fluxo = context.findAncestorStateOfType<_FluxoModalState>();
  if (fluxo != null) {
    fluxo.fechar(null);
  } else {
    Navigator.of(context).pop();
  }
}

/// Mantém uma única bottom sheet. As etapas navegam dentro dela, conservando
/// o estado dos formulários anteriores e os resultados aguardados pelo chamador.
class _FluxoModal extends StatefulWidget {
  const _FluxoModal({required this.builder, required this.aoFechar});

  final WidgetBuilder builder;
  final ValueChanged<Object?> aoFechar;

  @override
  State<_FluxoModal> createState() => _FluxoModalState();
}

class _FluxoModalState extends State<_FluxoModal> {
  final navegador = GlobalKey<NavigatorState>();
  final pendentes = <VoidCallback>{};
  bool fechando = false;

  void fechar(Object? resultado) {
    if (fechando || !mounted) return;
    fechando = true;
    FocusManager.instance.primaryFocus?.unfocus();
    widget.aoFechar(resultado);
  }

  Future<T?> abrirPagina<T>(WidgetBuilder builder) {
    if (fechando || !mounted) return Future<T?>.value();
    final resultado = Completer<T?>();
    void cancelar() {
      if (!resultado.isCompleted) resultado.complete(null);
    }

    pendentes.add(cancelar);
    navegador.currentState!.push<T>(_PaginaModal<T>(builder: builder)).then(
        (valor) {
      if (!resultado.isCompleted) resultado.complete(valor);
    }, onError: (Object erro, StackTrace pilha) {
      if (!resultado.isCompleted) resultado.completeError(erro, pilha);
    });
    return resultado.future.whenComplete(() => pendentes.remove(cancelar));
  }

  @override
  void dispose() {
    for (final cancelar in pendentes.toList()) {
      cancelar();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.94,
      child: NavigatorPopHandler<Object?>(
        onPopWithResult: (resultado) => navegador.currentState!.pop(resultado),
        child: Navigator(
          key: navegador,
          onGenerateRoute: (_) => _PaginaModal<Object?>(
            builder: widget.builder,
          ),
        ),
      ),
    );
  }
}

class _PaginaModal<T> extends PageRouteBuilder<T> {
  _PaginaModal({required WidgetBuilder builder})
      : super(
          pageBuilder: (context, _, __) => Material(
            color: Colors.white,
            child: Builder(builder: builder),
          ),
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        );
}

class ModalFormulario extends StatelessWidget {
  const ModalFormulario({
    super.key,
    required this.titulo,
    required this.conteudo,
    this.rodape,
    this.cabecalhoPersonalizado,
  });

  final String titulo;
  final Widget conteudo;
  final Widget? rodape;
  final Widget? cabecalhoPersonalizado;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.94,
        child: Column(
          children: [
            cabecalhoPersonalizado ?? cabecalho(context),
            const Divider(height: 1, color: Color(0xFFEAEAEA)),
            Expanded(child: corpo()),
            if (rodape != null) ...[
              const Divider(height: 1, color: Color(0xFFEAEAEA)),
              criarRodape(),
            ],
          ],
        ),
      ),
    );
  }

  Widget cabecalho(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      child: Row(
        children: [
          IconButton(
            tooltip: 'Voltar',
            icon: const Icon(Icons.arrow_back, color: Color(0xFF757575)),
            onPressed: () => fecharEtapaModal(context),
          ),
          Expanded(
            child: Text(
              titulo,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF29363D),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          IconButton(
            tooltip: 'Fechar painel',
            icon: const Icon(Icons.close, color: Color(0xFF757575)),
            onPressed: () => fecharPainelModal(context),
          ),
        ],
      ),
    );
  }

  Widget corpo() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 46, 20, 24),
      child: conteudo,
    );
  }

  Widget criarRodape() {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 28, 24, 26),
        child: SizedBox(width: double.infinity, child: rodape),
      ),
    );
  }
}
