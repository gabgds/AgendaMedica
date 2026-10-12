import 'package:flutter/material.dart';
import 'package:pex/shared/estilo/estilo_texto.dart';
import 'package:pex/shared/paciente/paciente.dart';

// Card de informações do paciente, com os dados capturados no cadastro.
class InformacoesPerfilPaciente extends StatelessWidget {
  const InformacoesPerfilPaciente({super.key, required this.paciente});

  final Paciente paciente;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 20),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF4F8),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          informacao('TELEFONE', formatarTelefone(paciente.telefone)),
          const SizedBox(height: 16),
          informacao('NASCIMENTO', formatarData(paciente.dataNascimento)),
          const SizedBox(height: 16),
          informacao('CPF', formatarCpf(paciente.cpf)),
          const SizedBox(height: 16),
          informacao('ENDEREÇO', paciente.endereco),
          const SizedBox(height: 16),
          informacao('EMAIL', paciente.email),
        ],
      ),
    );
  }

  Widget informacao(String titulo, String valor) {
    final preenchido = valor.trim().isNotEmpty;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: TextoComEstilo(
            titulo,
            cor: const Color(0xFF757575),
            tamanho: 13,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: TextoComEstilo(
            preenchido ? valor : 'Não informado',
            cor: preenchido ? const Color(0xFF29363D) : Colors.grey,
            tamanho: 14,
          ),
        ),
      ],
    );
  }

  String formatarData(DateTime? data) {
    if (data == null) return '';
    final dia = data.day.toString().padLeft(2, '0');
    final mes = data.month.toString().padLeft(2, '0');
    return '$dia/$mes/${data.year}';
  }

  String formatarTelefone(String valor) {
    final numeros = valor.replaceAll(RegExp(r'\D'), '');
    if (numeros.length != 10 && numeros.length != 11) return valor;
    final ddd = numeros.substring(0, 2);
    final corte = numeros.length - 4;
    return '($ddd) ${numeros.substring(2, corte)}-${numeros.substring(corte)}';
  }

  String formatarCpf(String valor) {
    final numeros = valor.replaceAll(RegExp(r'\D'), '');
    if (numeros.length != 11) return valor;
    return '${numeros.substring(0, 3)}.${numeros.substring(3, 6)}.'
        '${numeros.substring(6, 9)}-${numeros.substring(9)}';
  }
}
