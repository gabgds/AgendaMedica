import 'package:flutter_test/flutter_test.dart';
import 'package:pex/paginas/pacientes/paciente.dart';
import 'package:pex/shared/funcoes/senha.dart';

void main() {
  group('senha', () {
    test('confere a senha correta e recusa a errada', () {
      final gravada = gerarHashSenha('minhaSenha');

      expect(conferirSenha('minhaSenha', gravada), isTrue);
      expect(conferirSenha('outraSenha', gravada), isFalse);
    });

    test('a mesma senha gera valores diferentes por causa do salt', () {
      expect(gerarHashSenha('123456'), isNot(gerarHashSenha('123456')));
    });

    test('valor gravado em formato inválido não autentica', () {
      expect(conferirSenha('123456', '123456'), isFalse);
    });
  });

  group('idade do paciente', () {
    Paciente nascidoEm(DateTime data) =>
        Paciente(id: 1, nome: 'Teste', telefone: '', dataNascimento: data);

    test('conta o ano só depois do aniversário', () {
      final paciente = nascidoEm(DateTime(1990, 5, 20));

      expect(paciente.idade(DateTime(2026, 5, 19)), 35);
      expect(paciente.idade(DateTime(2026, 5, 20)), 36);
    });

    test('sem data de nascimento retorna null', () {
      expect(const Paciente(id: 1, nome: 'Teste', telefone: '').idade(), isNull);
    });
  });
}
