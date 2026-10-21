# Agenda Médica (PEX)

Aplicativo Flutter para o médico organizar consultas, pacientes, clínicas e
notas fiscais pendentes. Os dados ficam em um banco SQLite local (Drift).

## Como rodar

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs  # após mudar tabelas
flutter run
flutter test
```

## Organização

- `lib/database/app_database.dart`: tabelas do banco (segue o diagrama do grupo).
  O arquivo `app_database.g.dart` é gerado pelo `build_runner`; não edite à mão.
- `lib/database/banco.dart`: instância única do banco usada pelo app.
- `lib/repositorios/`: consultas e gravações (médicos, clínicas, pacientes,
  agendamentos e notas fiscais). As telas só falam com o banco por aqui.
- `lib/shared/usuario/sessao.dart`: médico logado. Todas as consultas filtram
  pelos dados desse médico.
- `test/`: testes dos repositórios (banco em memória) e da interface.

## Regras da nota fiscal

1. Ao agendar, o médico informa se a consulta precisa de nota fiscal.
2. Ao marcar a consulta como concluída, a nota fica **pendente** e aparece no
   aviso da tela inicial.
3. A pendência só sai quando o médico marca a nota como emitida.
