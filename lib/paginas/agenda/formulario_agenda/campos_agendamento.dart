import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pex/shared/estilo/estilo_texto.dart';
import 'package:pex/shared/formulario/campo_formulario.dart';

// Campos do formulário. A data, o horário e as seleções ficam no modal.
class CamposAgendamento extends StatelessWidget {
  const CamposAgendamento({
    super.key,
    required this.pacientes,
    required this.clinicas,
    required this.pacienteId,
    required this.clinicaId,
    required this.emitirNotaFiscal,
    required this.dataController,
    required this.horarioController,
    required this.duracaoController,
    required this.aoSelecionarPaciente,
    required this.aoSelecionarClinica,
    required this.aoSelecionarNotaFiscal,
    required this.escolherData,
    required this.escolherHorario,
  });

  final Map<int, String> pacientes;
  final Map<int, String> clinicas;
  final int? pacienteId;
  final int? clinicaId;
  final bool? emitirNotaFiscal;
  final TextEditingController dataController;
  final TextEditingController horarioController;
  final TextEditingController duracaoController;
  final ValueChanged<int?> aoSelecionarPaciente;
  final ValueChanged<int?> aoSelecionarClinica;
  final ValueChanged<bool> aoSelecionarNotaFiscal;
  final VoidCallback escolherData;
  final VoidCallback escolherHorario;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
        const SizedBox(height: 28),
        campoNotaFiscal(),
      ],
    );
  }

  InputDecoration decoracao(String titulo, {IconData? icone}) {
    return decoracaoCampoFormulario(
      titulo,
      compacto: true,
      suffixIcon: icone == null
          ? null
          : Icon(icone, color: const Color(0xFF9E9E9E), size: 20),
    );
  }

  Widget seletor(
    String titulo,
    Map<int, String> opcoes,
    int? selecionado,
    ValueChanged<int?> aoSelecionar,
  ) {
    return DropdownButtonFormField<int>(
      initialValue: selecionado,
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

  Widget campoNotaFiscal() {
    return FormField<bool>(
      initialValue: emitirNotaFiscal,
      validator: (valor) => valor == null ? 'Selecione Sim ou Não' : null,
      builder: (campo) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TextoComEstilo(
              'ESTE ATENDIMENTO PRECISA DE NOTA FISCAL?',
              cor: Color(0xFF757575),
              tamanho: 14,
              peso: FontWeight.bold,
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                opcaoNotaFiscal('Sim', true, campo),
                const SizedBox(width: 15),
                opcaoNotaFiscal('Não', false, campo),
              ],
            ),
            if (campo.hasError)
              Padding(
                padding: const EdgeInsets.only(top: 8, left: 18),
                child: Text(
                  campo.errorText!,
                  style: TextStyle(
                    color: Theme.of(campo.context).colorScheme.error,
                    fontSize: 12,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget opcaoNotaFiscal(String texto, bool valor, FormFieldState<bool> campo) {
    final selecionado = campo.value == valor;

    return Semantics(
      label: texto,
      checked: selecionado,
      inMutuallyExclusiveGroup: true,
      child: Material(
        color: const Color(0xFFE9F0F6),
        borderRadius: BorderRadius.circular(14),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () {
            campo.didChange(valor);
            aoSelecionarNotaFiscal(valor);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  selecionado ? Icons.radio_button_checked : Icons.circle,
                  size: 20,
                  color: selecionado ? const Color(0xFF009691) : Colors.white,
                ),
                const SizedBox(width: 5),
                TextoComEstilo(
                  texto,
                  cor: const Color(0xFF757575),
                  tamanho: 14,
                  peso: FontWeight.bold,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}
