import 'package:flutter/material.dart';

Future<bool> abrirConfirmacaoModal(
  BuildContext context, {
  required String titulo,
  required String mensagem,
  String textoConfirmar = 'Confirmar',
  String textoCancelar = 'Cancelar',
  bool destrutiva = false,
}) async {
  FocusScope.of(context).unfocus();
  final confirmado = await showDialog<bool>(
    context: context,
    useRootNavigator: true,
    builder: (contextDialogo) => AlertDialog(
      scrollable: true,
      title: Text(titulo),
      content: Text(mensagem),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(contextDialogo).pop(false),
          child: Text(textoCancelar),
        ),
        FilledButton(
          onPressed: () => Navigator.of(contextDialogo).pop(true),
          style: destrutiva
              ? FilledButton.styleFrom(
                  backgroundColor: const Color(0xFFFF3333),
                  foregroundColor: Colors.white,
                )
              : null,
          child: Text(textoConfirmar),
        ),
      ],
    ),
  );
  return confirmado == true;
}

class AcoesEtapaModal extends StatelessWidget {
  const AcoesEtapaModal({
    super.key,
    required this.aoConfirmar,
    required this.aoCancelar,
    this.textoConfirmar = 'Selecionar',
    this.textoCancelar = 'Cancelar',
    this.destrutiva = false,
  });

  final VoidCallback aoConfirmar;
  final VoidCallback aoCancelar;
  final String textoConfirmar;
  final String textoCancelar;
  final bool destrutiva;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.end,
      spacing: 12,
      runSpacing: 8,
      children: [
        TextButton(onPressed: aoCancelar, child: Text(textoCancelar)),
        FilledButton(
          onPressed: aoConfirmar,
          style: destrutiva
              ? FilledButton.styleFrom(
                  backgroundColor: const Color(0xFFFF3333),
                  foregroundColor: Colors.white,
                )
              : null,
          child: Text(textoConfirmar),
        ),
      ],
    );
  }
}
