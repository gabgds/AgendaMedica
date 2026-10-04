import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Campos do formulário. A data, o horário e as seleções ficam no modal.
class CamposAgendamento extends StatelessWidget {
  const CamposAgendamento({
    super.key,
    required this.pacientes,
    required this.clinicas,
    required this.pacienteId,
    required this.clinicaId,
    required this.dataController,
    required this.horarioController,
    required this.duracaoController,
    required this.aoSelecionarPaciente,
    required this.aoSelecionarClinica,
    required this.escolherData,
    required this.escolherHorario,
  });

  final Map<int, String> pacientes;
  final Map<int, String> clinicas;
  final int? pacienteId;
  final int? clinicaId;
  final TextEditingController dataController;
  final TextEditingController horarioController;
  final TextEditingController duracaoController;
  final ValueChanged<int?> aoSelecionarPaciente;
  final ValueChanged<int?> aoSelecionarClinica;
  final VoidCallback escolherData;
  final VoidCallback escolherHorario;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        seletor('PACIENTE', pacientes, pacienteId, aoSelecionarPaciente),
        const SizedBox(height: 28),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: campoData()),
            const SizedBox(width: 16),
            Expanded(child: campoHorario()),
          ],
        ),
        const SizedBox(height: 28),
        seletor(
          'CLÍNICA',
          // O valor 0 identifica Avulso somente no seletor, sem criar uma clínica.
          {0: 'Avulso', ...clinicas},
          clinicaId,
          aoSelecionarClinica,
        ),
        const SizedBox(height: 28),
        campoDuracao(),
      ],
    );
  }

  InputDecoration decoracao(String titulo, {IconData? icone}) {
    return InputDecoration(
      hintText: titulo,
      hintStyle: const TextStyle(
        color: Color(0xFF757575),
        fontSize: 14,
        fontWeight: FontWeight.bold,
      ),
      filled: true,
      fillColor: const Color(0xFFE8F0F6),
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      suffixIcon: icone == null
          ? null
          : Icon(icone, color: Color(0xFF9E9E9E), size: 20),
    );
  }

  Widget seletor(
    String titulo,
    Map<int, String> opcoes,
    int? selecionado,
    ValueChanged<int?> aoSelecionar,
  ) {
    return DropdownButtonFormField<int>(
      value: selecionado,
      isExpanded: true,
      decoration: decoracao(titulo),
      icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
      items: [
        for (final opcao in opcoes.entries)
          DropdownMenuItem(value: opcao.key, child: Text(opcao.value)),
      ],
      onChanged: opcoes.isEmpty ? null : aoSelecionar,
      validator: (valor) => valor == null ? 'Selecione uma opção' : null,
    );
  }

  Widget campoData() {
    return TextFormField(
      controller: dataController,
      readOnly: true,
      decoration: decoracao('DATA', icone: Icons.calendar_month_outlined),
      onTap: escolherData,
    );
  }

  Widget campoHorario() {
    return TextFormField(
      controller: horarioController,
      readOnly: true,
      decoration: decoracao('HORÁRIO', icone: Icons.access_time),
      onTap: escolherHorario,
      validator: (valor) {
        if (valor == null || valor.isEmpty) {
          return 'Selecione o horário';
        }
        return null;
      },
    );
  }

  Widget campoDuracao() {
    return TextFormField(
      controller: duracaoController,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      decoration: decoracao('DURAÇÃO (MINUTOS)'),
      validator: (valor) {
        final minutos = int.tryParse(valor ?? '');
        if (minutos == null || minutos <= 0) {
          return 'Informe uma duração maior que zero';
        }
        return null;
      },
    );
  }
}
