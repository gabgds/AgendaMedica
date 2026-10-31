import 'package:pex/shared/avisos/aviso.dart';
import 'package:flutter/material.dart';
import 'package:pex/shared/estilo/estilo_texto.dart';
import 'package:pex/repositorios/medicos_repositorio.dart';
import 'package:pex/shared/usuario/sessao.dart';
import 'card_perfil.dart';
import 'card_sair.dart';
import 'edicao_perfil.dart';
import 'modal_editar_perfil.dart';

class Opcoes extends StatefulWidget {
  const Opcoes({super.key, this.aoEditarPerfil});

  final ValueChanged<EdicaoPerfil>? aoEditarPerfil;

  @override
  State<Opcoes> createState() => _OpcoesState();
}

class _OpcoesState extends State<Opcoes> {
  bool modalAberto = false;
  bool saindo = false;

  Future<void> editarPerfil() async {
    if (modalAberto || saindo) return;
    modalAberto = true;
    try {
      final edicao = await abrirModalEditarPerfil(
        context,
        perfilInicial: medicoLogado!,
      );
      if (!mounted || edicao == null) return;
      final perfil = await atualizarMedico(
        id: medicoLogadoId,
        nome: edicao.nome,
        usuario: edicao.usuario,
        novaSenha: edicao.novaSenha,
      );
      await entrarESalvarSessao(perfil);
      widget.aoEditarPerfil?.call(edicao);
      if (!mounted) return;
      mostrarAviso(context, 'Perfil atualizado.');
    } on UsuarioJaCadastrado catch (erro) {
      if (!mounted) return;
      mostrarAviso(context, erro.toString());
    } finally {
      modalAberto = false;
    }
  }

  Future<void> sair() async {
    if (saindo) return;
    saindo = true;
    await sairDaSessao();
    if (!mounted) return;
    Navigator.of(context, rootNavigator: true).pushNamedAndRemoveUntil<void>(
      '/login',
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const ColoredBox(
          color: Colors.white,
          child: SizedBox(
            height: 86,
            width: double.infinity,
            child: Center(
              child: TextoComEstilo(
                'Opções',
                cor: Color(0xFF29363D),
                tamanho: 26,
                peso: FontWeight.bold,
              ),
            ),
          ),
        ),
        const Divider(height: 1, color: Color(0xFFEAEAEA)),
        Expanded(
          child: ColoredBox(
            color: const Color(0xFFF8F9FE),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(22, 40, 22, 24),
              children: [
                CardPerfil(aoEditar: editarPerfil),
                const SizedBox(height: 30),
                CardSair(aoSair: sair),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
