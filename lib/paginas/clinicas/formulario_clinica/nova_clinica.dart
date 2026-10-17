import 'package:pex/shared/clinica/clinica.dart';

class NovaClinica {
  const NovaClinica({
    required this.nome,
    required this.endereco,
    required this.telefone,
  });

  final String nome;
  final String endereco;
  final String telefone;

  Clinica paraClinica({required int id}) {
    return Clinica(id: id, nome: nome, endereco: endereco, telefone: telefone);
  }
}
