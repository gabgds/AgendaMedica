// Informações de perfil usadas pela interface, sem armazenar a senha.
class PerfilUsuario {
  const PerfilUsuario({this.nome = '', this.email = ''});

  final String nome;
  final String email;
}
