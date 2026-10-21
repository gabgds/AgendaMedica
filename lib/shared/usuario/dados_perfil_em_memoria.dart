import 'perfil_usuario.dart';

PerfilUsuario _perfil = const PerfilUsuario();

PerfilUsuario obterPerfilEmMemoria() => _perfil;

void iniciarPerfilEmMemoria({required String email}) {
  final emailInformado = email.trim();
  if (_perfil.email.toLowerCase() != emailInformado.toLowerCase()) {
    _perfil = PerfilUsuario(email: emailInformado);
  }
}

void atualizarPerfilEmMemoria(PerfilUsuario perfil) {
  _perfil = perfil;
}

void limparPerfilEmMemoria() {
  _perfil = const PerfilUsuario();
}
