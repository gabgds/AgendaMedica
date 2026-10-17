// PROVISÓRIO: o perfil do usuário é mantido apenas na memória.
// Carregar e salvar os dados do perfil no banco de dados com Drift.
// Manter em memória somente o estado da sessão.

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
