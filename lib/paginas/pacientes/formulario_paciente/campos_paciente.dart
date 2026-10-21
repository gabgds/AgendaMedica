import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pex/shared/formulario/campo_formulario.dart';
import 'package:pex/shared/formulario/validacoes_login_cadastro.dart';

class CamposPaciente extends StatelessWidget {
  const CamposPaciente({
    super.key,
    required this.nomeController,
    required this.dataController,
    required this.cpfController,
    required this.enderecoController,
    required this.emailController,
    required this.telefoneController,
    required this.escolherData,
    required this.clinicas,
    required this.clinicaId,
    required this.aoSelecionarClinica,
  });

  final TextEditingController nomeController;
  final TextEditingController dataController;
  final TextEditingController cpfController;
  final TextEditingController enderecoController;
  final TextEditingController emailController;
  final TextEditingController telefoneController;
  final VoidCallback escolherData;
  final Map<int, String> clinicas;
  final int? clinicaId;
  final ValueChanged<int?> aoSelecionarClinica;

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
        const SizedBox(height: 28),
        seletorClinica(),
      ],
    );
  }

  Widget seletorClinica() {
    final opcoes = {0: 'Avulso', ...clinicas};
    return DropdownButtonFormField<int>(
      key: ValueKey(opcoes.keys.join(',')),
      initialValue: opcoes.containsKey(clinicaId) ? clinicaId : null,
      isExpanded: true,
      decoration: decoracaoCampoFormulario('CLÍNICA', compacto: true),
      icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
      items: [
        for (final opcao in opcoes.entries)
          DropdownMenuItem(value: opcao.key, child: Text(opcao.value)),
      ],
      onChanged: aoSelecionarClinica,
      validator: (valor) => valor == null ? 'Selecione a clínica ou Avulso' : null,
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
