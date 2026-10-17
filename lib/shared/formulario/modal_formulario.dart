import 'package:flutter/material.dart';

// Abre um modal para qualquer formulário e devolve o resultado ao fechar.
// O formulário define o tipo T e entrega o resultado com Navigator.pop.
Future<T?> abrirModalFormulario<T>(
  BuildContext context, {
  required WidgetBuilder builder,
}) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.white,
    clipBehavior: Clip.antiAlias,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: builder,
  );
}

// Estrutura reutilizável: cabeçalho com seta, conteúdo rolável e rodapé opcional.
// Cada tela fornece seu título, seus campos e seus botões.
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
      // Mantém o formulário e o botão acima do teclado.
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
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
            onPressed: () => Navigator.pop(context),
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
          const SizedBox(width: 48),
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
