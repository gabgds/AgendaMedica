import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pex/shared/botões/botao.dart';
import '../clinica.dart';
import 'package:pex/shared/formulario/campo_formulario.dart';
import 'package:pex/shared/formulario/modal_formulario.dart';
import 'package:pex/shared/formulario/validacoes_login_cadastro.dart';
import 'nova_clinica.dart';

Future<NovaClinica?> abrirModalClinica(
  BuildContext context, {
  Clinica? clinicaInicial,
}) {
  return abrirModalFormulario<NovaClinica>(
    context,
    builder: (context) => ModalClinica(clinicaInicial: clinicaInicial),
  );
}

// O mesmo formulário serve para cadastrar e editar uma clínica.
class ModalClinica extends StatefulWidget {
  const ModalClinica({super.key, this.clinicaInicial});

  final Clinica? clinicaInicial;

  @override
  State<ModalClinica> createState() => _ModalClinicaState();
}

class _ModalClinicaState extends State<ModalClinica> {
  final chaveFormulario = GlobalKey<FormState>();
  final nomeController = TextEditingController();
  final enderecoController = TextEditingController();
  final telefoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final clinica = widget.clinicaInicial;
    if (clinica == null) return;
    nomeController.text = clinica.nome;
    enderecoController.text = clinica.endereco;
    telefoneController.text = clinica.telefone.replaceAll(RegExp(r'\D'), '');
  }

  @override
  void dispose() {
    nomeController.dispose();
    enderecoController.dispose();
    telefoneController.dispose();
    super.dispose();
  }

  void salvar() {
    if (!chaveFormulario.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    Navigator.pop(
      context,
      NovaClinica(
        nome: nomeController.text.trim(),
        endereco: enderecoController.text.trim(),
        telefone: telefoneController.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final editando = widget.clinicaInicial != null;
    return ModalFormulario(
      titulo: editando ? 'Editar clínica' : 'Nova clínica',
      conteudo: Form(
        key: chaveFormulario,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            FormInput(
              'NOME DA CLÍNICA',
              compacto: true,
              controller: nomeController,
              textCapitalization: TextCapitalization.words,
              textInputAction: TextInputAction.next,
              validator: (valor) => validarNome(valor) == null
                  ? null
                  : 'Digite o nome da clínica',
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
          ],
        ),
      ),
      rodape: SizedBox(
        height: 50,
        child: Button(
          editando ? 'Salvar alterações' : 'Cadastrar clínica',
          padding: EdgeInsets.zero,
          onPressed: salvar,
        ),
      ),
    );
  }
}
