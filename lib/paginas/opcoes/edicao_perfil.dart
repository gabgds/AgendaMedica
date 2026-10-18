class EdicaoPerfil {
  const EdicaoPerfil({
    required this.nome,
    required this.usuario,
    this.novaSenha,
  });

  final String nome;
  final String usuario;
  final String? novaSenha;
}
