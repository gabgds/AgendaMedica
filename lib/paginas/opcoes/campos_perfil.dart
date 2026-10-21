import 'package:flutter/material.dart';
import 'package:pex/shared/formulario/campo_formulario.dart';
import 'package:pex/shared/formulario/validacoes_login_cadastro.dart';

class CamposPerfil extends StatelessWidget {
  const CamposPerfil({
    super.key,
    required this.nomeController,
    required this.usuarioController,
    required this.senhaController,
    required this.confirmacaoController,
  });

  final TextEditingController nomeController;
  final TextEditingController usuarioController;
  final TextEditingController senhaController;
  final TextEditingController confirmacaoController;

  bool get alterandoSenha =>
      senhaController.text.isNotEmpty || confirmacaoController.text.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FormInput(
          'NOME',
          controller: nomeController,
          textCapitalization: TextCapitalization.words,
          textInputAction: TextInputAction.next,
          validator: validarNome,
        ),
        const SizedBox(height: 26),
        FormInput(
          'USUÁRIO',
          controller: usuarioController,
          textInputAction: TextInputAction.next,
          validator: validarUsuario,
        ),
        const SizedBox(height: 26),
        FormInput(
          'SENHA',
          senha: true,
          controller: senhaController,
          textInputAction: TextInputAction.next,
          validator: (valor) =>
              alterandoSenha ? validarSenhaCadastro(valor) : null,
        ),
        const SizedBox(height: 26),
        FormInput(
          'CONFIRMAR SENHA',
          senha: true,
          controller: confirmacaoController,
          textInputAction: TextInputAction.done,
          validator: (valor) => alterandoSenha
              ? confirmarSenha(valor, senhaController.text)
              : null,
        ),
      ],
    );
  }
}
