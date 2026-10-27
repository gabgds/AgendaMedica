class Paciente {
  const Paciente({
    required this.id,
    required this.nome,
    required this.telefone,
    this.dataNascimento,
    this.cpf = '',
    this.endereco = '',
    this.email = '',
  });

  final int id;
  final String nome;
  final String telefone;
  final DateTime? dataNascimento;
  final String cpf;
  final String endereco;
  final String email;

  String get telefoneFormatado {
    final numeros = telefone.replaceAll(RegExp(r'\D'), '');
    if (numeros.length != 10 && numeros.length != 11) return telefone;
    final ddd = numeros.substring(0, 2);
    final corte = numeros.length - 4;
    return '($ddd) ${numeros.substring(2, corte)}-${numeros.substring(corte)}';
  }

  int? idade([DateTime? referencia]) {
    final nascimento = dataNascimento;
    if (nascimento == null) return null;
    final hoje = referencia ?? DateTime.now();
    var anos = hoje.year - nascimento.year;
    final fezAniversario = hoje.month > nascimento.month ||
        (hoje.month == nascimento.month && hoje.day >= nascimento.day);
    if (!fezAniversario) anos--;
    return anos;
  }
}
