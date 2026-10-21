import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';

String gerarHashSenha(String senha, {String? salt}) {
  final saltUsado = salt ?? _gerarSalt();
  final hash = sha256.convert(utf8.encode('$saltUsado$senha')).toString();
  return '$saltUsado\$$hash';
}

bool conferirSenha(String senha, String senhaGravada) {
  final partes = senhaGravada.split('\$');
  if (partes.length != 2) return false;
  return gerarHashSenha(senha, salt: partes[0]) == senhaGravada;
}

String _gerarSalt() {
  final aleatorio = Random.secure();
  final bytes = List<int>.generate(16, (_) => aleatorio.nextInt(256));
  return base64Url.encode(bytes);
}
