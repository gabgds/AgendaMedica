import '../clinica.dart';

class NovaClinica {
  const NovaClinica({
    required this.nome,
    required this.endereco,
  });

  final String nome;
  final String endereco;

  Clinica paraClinica({required int id}) {
    return Clinica(id: id, nome: nome, endereco: endereco);
  }
}
