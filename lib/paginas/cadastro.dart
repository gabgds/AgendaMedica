import 'package:pex/shared/avisos/aviso.dart';
import 'package:flutter/material.dart';
import '../shared/formulario/estilo_fonte_login.dart';
import '../shared/formulario/campo_formulario.dart';
import '../shared/botões/botao.dart';
import '../shared/formulario/validacoes_login_cadastro.dart';
import '../repositorios/medicos_repositorio.dart';

class Cadastro extends StatefulWidget {
  const Cadastro({super.key});

  @override
  State<Cadastro> createState() => _CadastroState();
}

class _CadastroState extends State<Cadastro> {
  final chaveFormulario = GlobalKey<FormState>();
  final nomeController = TextEditingController();
  final usuarioController = TextEditingController();
  final senhaController = TextEditingController();
  bool cadastrando = false;

  Future<void> cadastrar() async {
    if (cadastrando || !chaveFormulario.currentState!.validate()) {
      return;
    }

    cadastrando = true;
    try {
      await cadastrarMedico(
        nome: nomeController.text,
        usuario: usuarioController.text,
        senha: senhaController.text,
      );
      if (!mounted) return;
      mostrarAviso(context, 'Conta criada! Entre com seu usuário e senha.');
      Navigator.pop(context);
    } on UsuarioJaCadastrado catch (erro) {
      if (mounted) mostrarAviso(context, erro.toString());
    } finally {
      cadastrando = false;
    }
  }

  @override
  void dispose() {
    nomeController.dispose();
    usuarioController.dispose();
    senhaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton.filled(
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
          controller: nomeController,
          validator: validarNome,
        ),
        const SizedBox(height: 26),
        FormInput(
          'USUÁRIO',
          controller: usuarioController,
          validator: validarUsuario,
        ),
        const SizedBox(height: 26),
        FormInput(
          'SENHA',
          senha: true,
          controller: senhaController,
          validator: validarSenhaCadastro,
        ),
        const SizedBox(height: 26),
        FormInput('CONFIRMAR SENHA', senha: true, validator: (valor) {
          return confirmarSenha(valor, senhaController.text);
        }),
        const SizedBox(height: 26),
        Button('Criar conta', onPressed: cadastrar),
      ],
    );
  }
}
