String obterIniciais(String nome) {
  final partes = nome.trim().split(RegExp(r'\s+'));

  if (partes.first.isEmpty) {
    return '';
  }

  if (partes.length == 1) {
    return partes.first[0].toUpperCase();
  }

  return '${partes.first[0]}${partes.last[0]}'.toUpperCase();
}