import 'package:pex/shared/usuario/perfil_usuario.dart';

class EdicaoPerfil {
  const EdicaoPerfil({
    required this.nome,
    required this.email,
    this.novaSenha,
  });

  final String nome;
  final String email;
  final String? novaSenha;

  PerfilUsuario paraPerfil() => PerfilUsuario(nome: nome, email: email);
}
