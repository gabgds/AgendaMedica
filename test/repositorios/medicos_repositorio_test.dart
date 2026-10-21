import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pex/database/app_database.dart';
import 'package:pex/repositorios/medicos_repositorio.dart';
import 'package:pex/shared/usuario/sessao.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqlite3/sqlite3.dart';
import '../helpers/banco_teste.dart';

void main() {
  late AppDatabase bancoTeste;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    bancoTeste = criarBancoTeste();
  });
  tearDown(() => bancoTeste.close());

  test('cadastra médico sem gravar a senha em texto puro', () async {
    final medico = await cadastrarMedico(
      nome: ' Dr. Carlos ',
      usuario: ' Carlos ',
      senha: 'segredo1',
    );

    expect(medico.nome, 'Dr. Carlos');
    expect(medico.usuario, 'carlos');

    final gravado = await bancoTeste.select(bancoTeste.medicos).getSingle();
    expect(gravado.senha, isNot(contains('segredo1')));
  });

  test('não permite dois médicos com o mesmo usuário', () async {
    await cadastrarMedico(nome: 'A', usuario: 'carlos', senha: '123456');

    expect(
      cadastrarMedico(nome: 'B', usuario: 'CARLOS', senha: '654321'),
      throwsA(isA<UsuarioJaCadastrado>()),
    );
  });

  test('autentica com a senha correta e recusa a incorreta', () async {
    await cadastrarMedico(nome: 'A', usuario: 'carlos', senha: '123456');

    final certo = await autenticarMedico(usuario: 'Carlos', senha: '123456');
    final errado = await autenticarMedico(usuario: 'carlos', senha: '000000');
    final inexistente =
        await autenticarMedico(usuario: 'ana', senha: '123456');

    expect(certo?.nome, 'A');
    expect(errado, isNull);
    expect(inexistente, isNull);
  });

  test('atualiza perfil e troca a senha só quando informada', () async {
    final medico =
        await cadastrarMedico(nome: 'A', usuario: 'carlos', senha: '123456');

    await atualizarMedico(id: medico.id, nome: 'Novo', usuario: 'novo');
    expect(
      await autenticarMedico(usuario: 'novo', senha: '123456'),
      isNotNull,
    );

    await atualizarMedico(
      id: medico.id,
      nome: 'Novo',
      usuario: 'novo',
      novaSenha: 'outra123',
    );
    expect(await autenticarMedico(usuario: 'novo', senha: '123456'), isNull);
    expect(await autenticarMedico(usuario: 'novo', senha: 'outra123'), isNotNull);
  });

  test('não permite trocar para o usuário de outro médico', () async {
    await cadastrarMedico(nome: 'A', usuario: 'carlos', senha: '123456');
    final b = await cadastrarMedico(nome: 'B', usuario: 'ana', senha: '123456');

    expect(
      atualizarMedico(id: b.id, nome: 'B', usuario: 'carlos'),
      throwsA(isA<UsuarioJaCadastrado>()),
    );
  });

  group('sessão salva', () {
    test('continua logado ao abrir o app de novo', () async {
      final medico =
          await cadastrarMedico(nome: 'A', usuario: 'carlos', senha: '123456');
      await entrarESalvarSessao(medico);

      encerrarSessao();
      await restaurarSessao();

      expect(medicoLogado?.usuario, 'carlos');
    });

    test('depois de sair, abre sem ninguém logado', () async {
      final medico =
          await cadastrarMedico(nome: 'A', usuario: 'carlos', senha: '123456');
      await entrarESalvarSessao(medico);
      await sairDaSessao();

      await restaurarSessao();

      expect(medicoLogado, isNull);
    });

    test('ignora sessão de médico que não existe mais', () async {
      SharedPreferences.setMockInitialValues({'medico_logado_id': 99});

      await restaurarSessao();

      expect(medicoLogado, isNull);
    });
  });

  test('migra banco da versão 1, trocando email por usuario', () async {
    final antigo = sqlite3.openInMemory()
      ..execute('CREATE TABLE medicos (id INTEGER PRIMARY KEY AUTOINCREMENT, '
          'nome TEXT NOT NULL, email TEXT NOT NULL UNIQUE, senha TEXT NOT NULL)')
      ..execute("INSERT INTO medicos (nome, email, senha) VALUES ('A', 'carlos', 'x')")
      ..execute('PRAGMA user_version = 1');
    final migrado = AppDatabase.paraTeste(NativeDatabase.opened(antigo));
    addTearDown(migrado.close);

    final medico = await migrado.select(migrado.medicos).getSingle();
    expect(medico.usuario, 'carlos');
  });
}
