import 'package:flutter/material.dart';

class CardListagem extends StatelessWidget {
  const CardListagem({
    super.key,
    required this.conteudo,
    this.aoClicar,
    this.padding = const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
  });

  final Widget conteudo;
  final VoidCallback? aoClicar;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      surfaceTintColor: Colors.transparent,
      elevation: 3,
      shadowColor: Colors.black26,
      borderRadius: BorderRadius.circular(12),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: aoClicar,
        child: Padding(padding: padding, child: conteudo),
      ),
    );
  }
}
