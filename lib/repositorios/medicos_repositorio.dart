import 'package:drift/drift.dart';
import 'package:pex/database/app_database.dart';
import 'package:pex/database/banco.dart';
import 'package:pex/shared/funcoes/senha.dart';
import 'package:pex/shared/usuario/perfil_usuario.dart';

class UsuarioJaCadastrado implements Exception {
  const UsuarioJaCadastrado();

  @override
  String toString() => 'Este usuário já está em uso.';
}

String normalizarUsuario(String usuario) => usuario.trim().toLowerCase();

PerfilUsuario _paraPerfil(MedicoRegistro medico) =>
    PerfilUsuario(id: medico.id, nome: medico.nome, usuario: medico.usuario);

Future<MedicoRegistro?> _medicoPorUsuario(String usuario) {
  return (banco.select(banco.medicos)
        ..where((m) => m.usuario.equals(normalizarUsuario(usuario))))
      .getSingleOrNull();
}

Future<PerfilUsuario?> buscarMedico(int id) async {
  final medico = await (banco.select(banco.medicos)
        ..where((m) => m.id.equals(id)))
      .getSingleOrNull();
  return medico == null ? null : _paraPerfil(medico);
}

Future<PerfilUsuario> cadastrarMedico({
  required String nome,
  required String usuario,
  required String senha,
}) async {
  if (await _medicoPorUsuario(usuario) != null) {
    throw const UsuarioJaCadastrado();
  }

  final id = await banco.into(banco.medicos).insert(MedicosCompanion.insert(
        nome: nome.trim(),
        usuario: normalizarUsuario(usuario),
        senha: gerarHashSenha(senha),
      ));
  return PerfilUsuario(
    id: id,
    nome: nome.trim(),
    usuario: normalizarUsuario(usuario),
  );
}

Future<PerfilUsuario?> autenticarMedico({
  required String usuario,
  required String senha,
}) async {
  final medico = await _medicoPorUsuario(usuario);
  if (medico == null || !conferirSenha(senha, medico.senha)) return null;
  return _paraPerfil(medico);
}

Future<PerfilUsuario> atualizarMedico({
  required int id,
  required String nome,
  required String usuario,
  String? novaSenha,
}) async {
  final existente = await _medicoPorUsuario(usuario);
  if (existente != null && existente.id != id) {
    throw const UsuarioJaCadastrado();
  }

  await (banco.update(banco.medicos)..where((m) => m.id.equals(id))).write(
    MedicosCompanion(
      nome: Value(nome.trim()),
      usuario: Value(normalizarUsuario(usuario)),
      senha: novaSenha == null
          ? const Value.absent()
          : Value(gerarHashSenha(novaSenha)),
    ),
  );
  return PerfilUsuario(
    id: id,
    nome: nome.trim(),
    usuario: normalizarUsuario(usuario),
  );
}
