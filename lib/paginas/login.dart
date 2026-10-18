import 'package:flutter/material.dart';
import '../shared/formulario/estilo_fonte_login.dart';
import '../shared/formulario/campo_formulario.dart';
import '../shared/botões/botao.dart';
import 'cadastro.dart';
import '../shared/formulario/validacoes_login_cadastro.dart';
import 'inicio.dart';
import '../repositorios/medicos_repositorio.dart';
import '../shared/usuario/sessao.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final chaveFormulario = GlobalKey<FormState>();
  final usuarioController = TextEditingController();
  final senhaController = TextEditingController();
  bool entrando = false;

  @override
  void dispose() {
    usuarioController.dispose();
    senhaController.dispose();
    super.dispose();
  }

  Future<void> entrar() async {
    if (entrando || !chaveFormulario.currentState!.validate()) {
      return;
    }

    entrando = true;
    try {
      final medico = await autenticarMedico(
        usuario: usuarioController.text,
        senha: senhaController.text,
      );
      if (!mounted) return;
      if (medico == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Usuário ou senha incorretos.')),
        );
        return;
      }

      await entrarESalvarSessao(medico);
      if (!mounted) return;
      senhaController.clear();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Inicio()),
      );
    } finally {
      entrando = false;
    }
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
          'USUÁRIO',
          controller: usuarioController,
          validator: validarUsuario,
        ),
        const SizedBox(height: 22),

        FormInput(
          'SENHA',
          senha: true,
          controller: senhaController,
          validator: validarSenha,
        ),
        const SizedBox(height: 22),

        Button('Entrar', onPressed: entrar),
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
