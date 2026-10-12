import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pex/shared/estilo/estilo_texto.dart';
import 'package:pex/shared/formulario/campo_formulario.dart';
import 'package:pex/shared/formulario/validacoes_login_cadastro.dart';

// O modal guarda os valores; este componente monta e valida os campos.
class CamposPaciente extends StatelessWidget {
  const CamposPaciente({
    super.key,
    required this.nomeController,
    required this.dataController,
    required this.cpfController,
    required this.enderecoController,
    required this.emailController,
    required this.telefoneController,
    required this.clinicas,
    required this.clinicaId,
    required this.emitirNotaFiscal,
    required this.escolherData,
    required this.aoSelecionarClinica,
    required this.aoSelecionarNotaFiscal,
  });

  final TextEditingController nomeController;
  final TextEditingController dataController;
  final TextEditingController cpfController;
  final TextEditingController enderecoController;
  final TextEditingController emailController;
  final TextEditingController telefoneController;
  final Map<int, String> clinicas;
  final int? clinicaId;
  final bool? emitirNotaFiscal;
  final VoidCallback escolherData;
  final ValueChanged<int?> aoSelecionarClinica;
  final ValueChanged<bool> aoSelecionarNotaFiscal;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FormInput(
          'NOME COMPLETO',
          compacto: true,
          controller: nomeController,
          validator: validarNome,
          textCapitalization: TextCapitalization.words,
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: 28),
        FormInput(
          'DATA DE NASCIMENTO',
          compacto: true,
          controller: dataController,
          readOnly: true,
          onTap: escolherData,
          validator: (valor) => (valor ?? '').isEmpty
              ? 'Selecione a data de nascimento'
              : null,
          suffixIcon: IconButton(
            tooltip: 'Escolher data de nascimento',
            onPressed: escolherData,
            icon: const Icon(
              Icons.calendar_month_outlined,
              color: Color(0xFF9E9E9E),
              size: 20,
            ),
          ),
        ),
        const SizedBox(height: 28),
        FormInput(
          'CPF',
          compacto: true,
          controller: cpfController,
          teclado: TextInputType.number,
          textInputAction: TextInputAction.next,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(11),
          ],
          validator: validarCpf,
        ),
        const SizedBox(height: 28),
        FormInput(
          'ENDEREÇO',
          compacto: true,
          controller: enderecoController,
          textCapitalization: TextCapitalization.words,
          textInputAction: TextInputAction.next,
          validator: (valor) => (valor ?? '').trim().isEmpty
              ? 'Digite o endereço'
              : null,
        ),
        const SizedBox(height: 28),
        FormInput(
          'E-MAIL',
          compacto: true,
          controller: emailController,
          teclado: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          validator: validarEmail,
        ),
        const SizedBox(height: 28),
        FormInput(
          'TELEFONE',
          compacto: true,
          controller: telefoneController,
          teclado: TextInputType.phone,
          textInputAction: TextInputAction.done,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(11),
          ],
        ),
        const SizedBox(height: 20),
        campoNotaFiscal(),
        const SizedBox(height: 28),
        DropdownButtonFormField<int>(
          initialValue: clinicaId,
          isExpanded: true,
          style: const TextStyle(color: Color(0xFF29363D), fontSize: 14),
          decoration: decoracaoCampoFormulario('CLÍNICA', compacto: true),
          icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
          items: [
            const DropdownMenuItem(value: 0, child: Text('Avulso')),
            for (final clinica in clinicas.entries)
              if (clinica.key != 0)
                DropdownMenuItem(
                  value: clinica.key,
                  child: Text(clinica.value),
                ),
          ],
          onChanged: aoSelecionarClinica,
          validator: (valor) => valor == null
              ? 'Selecione uma clínica ou Avulso'
              : null,
        ),
      ],
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
              'EMITIR NOTA FISCAL',
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

  String? validarCpf(String? valor) {
    final cpf = (valor ?? '').trim();
    if (cpf.isEmpty) {
      return 'Digite o CPF';
    }
    if (!RegExp(r'^[0-9]+$').hasMatch(cpf)) {
      return 'Use apenas números no CPF';
    }
    if (cpf.length != 11) {
      return 'O CPF deve ter 11 dígitos';
    }
    return null;
  }
}
