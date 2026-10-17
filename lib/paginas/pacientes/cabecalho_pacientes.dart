import 'package:flutter/material.dart';
import 'package:pex/shared/botões/botao.dart';
import 'package:pex/shared/estilo/estilo_texto.dart';

// Cabeçalho da página: título, botão de cadastro e campo de busca.
class CabecalhoPacientes extends StatelessWidget {
  const CabecalhoPacientes({
    super.key,
    required this.aoBuscar,
    this.aoAdicionar,
  });

  final ValueChanged<String> aoBuscar;
  final VoidCallback? aoAdicionar;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(22, 20, 22, 20),
        child: Column(
          children: [
            tituloEBotao(),
            const SizedBox(height: 24),
            campoBusca(),
          ],
        ),
      ),
    );
  }

  Widget tituloEBotao() {
    return Row(
      children: [
        const Expanded(
          child: TextoComEstilo(
            'Pacientes',
            cor: Color(0xFF29363D),
            tamanho: 26,
            peso: FontWeight.bold,
          ),
        ),
        SizedBox(
          width: 98,
          height: 44,
          child: Button(
            '+ Novo',
            padding: EdgeInsets.zero,
            pesoTexto: FontWeight.normal,
            onPressed: aoAdicionar ?? () {},
          ),
        ),
      ],
    );
  }

  Widget campoBusca() {
    return SizedBox(
      height: 38,
      child: TextField(
        onChanged: aoBuscar,
        textInputAction: TextInputAction.search,
        style: const TextStyle(fontSize: 14),
        decoration: InputDecoration(
          hintText: 'Buscar paciente...',
          hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
          prefixIcon: const Icon(Icons.search, color: Colors.grey, size: 22),
          prefixIconConstraints: const BoxConstraints(minWidth: 36, minHeight: 36),
          filled: true,
          fillColor: const Color(0xFFE9F0F5),
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
