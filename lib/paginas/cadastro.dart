import 'package:flutter/material.dart';
import '../shared/formulario/estilo_fonte_login.dart';
import '../shared/formulario/campo_formulario.dart';
import '../shared/botões/botao.dart';
import '../shared/formulario/validacoes_login_cadastro.dart';

class Cadastro extends StatefulWidget {
  const Cadastro({super.key});

  @override
  State<Cadastro> createState() => _CadastroState();
}

class _CadastroState extends State<Cadastro> {
  final chaveFormulario = GlobalKey<FormState>();
  final senhaController = TextEditingController();

  void cadastrar() {
    if (!chaveFormulario.currentState!.validate()) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Campos válidos!')),
    );
  }

  @override
  void dispose() {
    senhaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading:
        IconButton.filled(
          style: IconButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
          ),
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: chaveFormulario,
            child: conteudo(),
          ),
        ),
      ),
    );
  }

  Widget conteudo() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        LoginFontStyle('Criar conta'),
        const SizedBox(height: 28),
        FormInput(
          'NOME',
          validator: validarNome,
        ),
        const SizedBox(height: 26),
        FormInput(
          'EMAIL',
          teclado: TextInputType.emailAddress,
          validator: validarEmail,
        ),
        const SizedBox(height: 26),
        FormInput(
          'SENHA',
          senha: true,
          controller: senhaController,
          validator: validarSenha,
        ),
        const SizedBox(height: 26),
        FormInput(
          'CONFIRMAR SENHA',
          senha: true,
          validator: (valor){
            return confirmarSenha(valor, senhaController.text);
          }
        ),
        const SizedBox(height: 26),
        Button('Criar conta', onPressed: cadastrar),
      ],
    );
  }
}