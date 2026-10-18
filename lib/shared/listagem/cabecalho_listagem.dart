import 'package:flutter/material.dart';
import 'package:pex/shared/botões/botao.dart';
import 'package:pex/shared/estilo/estilo_texto.dart';

class CabecalhoListagem extends StatelessWidget {
  const CabecalhoListagem({
    super.key,
    required this.titulo,
    required this.textoBusca,
    required this.aoBuscar,
    this.aoAdicionar,
    this.textoBotao = '+ Novo',
    this.larguraBotao = 98,
    this.alturaBotao = 44,
    this.tamanhoTextoBotao = 18,
    this.tamanhoTitulo = 26,
  });

  final String titulo;
  final String textoBusca;
  final ValueChanged<String> aoBuscar;
  final VoidCallback? aoAdicionar;
  final String textoBotao;
  final double larguraBotao;
  final double alturaBotao;
  final double tamanhoTextoBotao;
  final double tamanhoTitulo;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(22, 20, 22, 20),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextoComEstilo(
                    titulo,
                    cor: const Color(0xFF29363D),
                    tamanho: tamanhoTitulo,
                    peso: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  width: larguraBotao,
                  height: alturaBotao,
                  child: Button(
                    textoBotao,
                    padding: EdgeInsets.zero,
                    pesoTexto: FontWeight.normal,
                    tamanhoTexto: tamanhoTextoBotao,
                    onPressed: aoAdicionar,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 38,
              child: TextField(
                onChanged: aoBuscar,
                textInputAction: TextInputAction.search,
                style: const TextStyle(fontSize: 14),
                decoration: InputDecoration(
                  hintText: textoBusca,
                  hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Colors.grey,
                    size: 22,
                  ),
                  prefixIconConstraints: const BoxConstraints(
                    minWidth: 36,
                    minHeight: 36,
                  ),
                  filled: true,
                  fillColor: const Color(0xFFE9F0F5),
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
