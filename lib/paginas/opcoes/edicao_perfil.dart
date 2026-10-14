import 'package:pex/shared/usuario/perfil_usuario.dart';

// Resultado do formulário. A nova senha é entregue ao chamador, sem persistir.
class EdicaoPerfil {
  const EdicaoPerfil({
    required this.nome,
    required this.email,
    this.novaSenha,
  });

  final String nome;
  final String email;
  // null significa que o usuário deixou os dois campos de senha vazios.
  final String? novaSenha;

  PerfilUsuario paraPerfil() => PerfilUsuario(nome: nome, email: email);
}
