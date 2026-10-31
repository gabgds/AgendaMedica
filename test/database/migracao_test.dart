import 'package:flutter_test/flutter_test.dart';
import 'package:pex/database/app_database.dart';
import '../helpers/banco_antigo.dart';

void main() {
  for (final versao in [1, 2]) {
    test('migra da versão $versao preservando cadastros e consultas', () async {
      final banco = abrirBancoAntigo(versao);
      addTearDown(banco.close);

      final pacientes = await banco.select(banco.pacientes).get();
      expect(pacientes.map((p) => p.id), [20, 21]);
      expect(pacientes.map((p) => p.nomeCompleto), ['Maria', 'João']);
      expect(pacientes.first.medicoId, 1);
      expect(pacientes.first.cpf, '12345678901');
      expect(pacientes.first.telefone, '47999998888');
      expect(
          (await banco.select(banco.medicos).get()).single.usuario, 'carlos');
      expect(await banco.select(banco.clinicas).get(), hasLength(2));

      final consultas = await banco.select(banco.agendamentos).get();
      expect(consultas.map((a) => a.id), [100, 101, 102]);
      // A consulta já era na Norte, mesmo com o cadastro antigo ligado ao Centro.
      expect(consultas.first.clinicaId, 11);
      expect(consultas.first.pacienteId, 20);
      expect(consultas.first.sala, '3');
      expect(consultas[1].clinicaId, isNull);
      expect(consultas[1].status, StatusAgendamento.cancelado);
      expect(consultas[2].status, StatusAgendamento.concluido);
      final nota = (await banco.select(banco.notasFiscais).get()).single;
      expect(nota.agendamentoId, 102);
      expect(nota.valor, 120);
      expect(nota.emitida, isFalse);

      final colunas =
          await banco.customSelect('PRAGMA table_info(pacientes)').get();
      expect(colunas.map((c) => c.read<String>('name')),
          isNot(contains('clinica_id')));
      expect(
          await banco.customSelect('PRAGMA foreign_key_check').get(), isEmpty);
      expect(
          (await banco.customSelect('PRAGMA foreign_keys').getSingle())
              .read<int>('foreign_keys'),
          1);
      expect(
          (await banco.customSelect('PRAGMA user_version').getSingle())
              .read<int>('user_version'),
          3);
    });
  }
}
