import 'app_database.dart';

AppDatabase? _banco;

AppDatabase get banco => _banco ??= AppDatabase();

void definirBanco(AppDatabase novoBanco) {
  _banco = novoBanco;
}
