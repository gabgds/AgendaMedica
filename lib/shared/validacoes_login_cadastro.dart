String? validarNome(String? valor) {
  if (valor == null || valor.trim().isEmpty) {
    return 'Digite seu nome';
  }

  return null;
}

String? validarEmail(String? valor) {
  final email = (valor ?? '').trim();

  if (email.isEmpty) {
    return 'Digite seu e-mail';
  }

  if (!RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(email)) {
    return 'Digite um e-mail válido';
  }

  return null;
}

String? validarSenha(String? valor) {
  if (valor == null || valor.trim().isEmpty) {
    return 'Digite sua senha';
  }

  return null;
}

String? validarSenhaCadastro(String? valor) {
  final erro = validarSenha(valor);

  if (erro != null) {
    return erro;
  }

  if (valor!.length < 6) {
    return 'A senha deve ter pelo menos 6 caracteres';
  }

  return null;
}

String? confirmarSenha(String? valor, String senha) {
  if (valor == null || valor.isEmpty) {
    return 'Confirme sua senha';
  }

  if (valor != senha) {
    return 'As senhas não coincidem';
  }

  return null;
}