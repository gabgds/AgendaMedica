import 'package:flutter/material.dart';
import 'shared/login_font_style.dart';
import 'shared/form_input.dart';
import 'shared/green_button.dart';
import 'cadastro.dart';
import 'shared/validacoes_login_cadastro.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final chaveFormulario = GlobalKey<FormState>();

  void entrar() {
    if (!chaveFormulario.currentState!.validate()) {
      return;
    }

    // Coloque a autenticação aqui quando conectar o login.
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Campos válidos!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: chaveFormulario,
        child: conteudo(),
      ),
    );
  }

  Widget conteudo() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(child: LoginFontStyle('Bem-vindo')),
        Center(child: Subtitulo('Entre para continuar')),
        const SizedBox(height: 32),

        FormInput(
          'EMAIL',
          teclado: TextInputType.emailAddress,
          validator: validarEmail,
        ),
        const SizedBox(height: 22),

        FormInput(
          'SENHA',
          senha: true,
          validator: validarSenha,
        ),
        const SizedBox(height: 22),

        GreenButton('Entrar', onPressed: entrar),
        const SizedBox(height: 22),

        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Cadastro()),
            );
          },
          child: Center(
            child:
              const Subtitulo('Criar conta'),
          ),
        ),
      ],
    );
  }
}