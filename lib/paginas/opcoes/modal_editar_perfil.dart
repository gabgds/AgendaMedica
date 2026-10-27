import 'package:flutter/material.dart';
import 'package:pex/shared/botões/botao.dart';
import 'package:pex/shared/formulario/modal_formulario.dart';
import 'package:pex/shared/usuario/perfil_usuario.dart';

import 'campos_perfil.dart';
import 'edicao_perfil.dart';

Future<EdicaoPerfil?> abrirModalEditarPerfil(
  BuildContext context, {
  PerfilUsuario perfilInicial = const PerfilUsuario(),
}) {
  return abrirModalFormulario<EdicaoPerfil>(
    context,
    builder: (context) => ModalEditarPerfil(perfilInicial: perfilInicial),
  );
}

class ModalEditarPerfil extends StatefulWidget {
  const ModalEditarPerfil({super.key, required this.perfilInicial});

  final PerfilUsuario perfilInicial;

  @override
  State<ModalEditarPerfil> createState() => _ModalEditarPerfilState();
}

class _ModalEditarPerfilState extends State<ModalEditarPerfil> {
  final chaveFormulario = GlobalKey<FormState>();
  final nomeController = TextEditingController();
  final usuarioController = TextEditingController();
  final senhaController = TextEditingController();
  final confirmacaoController = TextEditingController();
  bool confirmando = false;

  @override
  void initState() {
    super.initState();
    nomeController.text = widget.perfilInicial.nome;
    usuarioController.text = widget.perfilInicial.usuario;
  }

  @override
  void dispose() {
    nomeController.dispose();
    usuarioController.dispose();
    senhaController.dispose();
    confirmacaoController.dispose();
    super.dispose();
  }

  Future<void> editarPerfil() async {
    if (confirmando) return;
    if (!chaveFormulario.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    confirmando = true;
    try {
      final edicao = EdicaoPerfil(
        nome: nomeController.text.trim(),
        usuario: usuarioController.text.trim(),
        novaSenha: senhaController.text.isEmpty ? null : senhaController.text,
      );
      final confirmado = await showDialog<bool>(
        context: context,
        builder: (contextDialogo) => AlertDialog(
          title: const Text('Salvar alterações do perfil?'),
          content: const Text(
            'Deseja salvar as alterações do seu perfil? '
            'Se você alterou o usuário ou a senha, utilize os novos dados '
            'no próximo acesso.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(contextDialogo, false),
              child: const Text('Continuar editando'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(contextDialogo, true),
              child: const Text('Sim, salvar'),
            ),
          ],
        ),
      );
      if (!mounted || confirmado != true) return;
      Navigator.pop(context, edicao);
    } finally {
      confirmando = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ModalFormulario(
      titulo: 'Editar perfil',
      conteudo: Form(
        key: chaveFormulario,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: CamposPerfil(
          nomeController: nomeController,
          usuarioController: usuarioController,
          senhaController: senhaController,
          confirmacaoController: confirmacaoController,
        ),
      ),
      rodape: SizedBox(
        height: 50,
        child: Button(
          'Editar perfil',
          cor: const Color(0xFF207CD4),
          padding: EdgeInsets.zero,
          onPressed: editarPerfil,
        ),
      ),
    );
  }
}
