// Isso é provisório, porque eu já coloquei streams pra mostrar as coisas
// do inicio. Desse jeito eu separei as informações específicas da apresentação
// delas com os widgets. O banco de dados que vai substituir isso. - Gustavo

import 'package:flutter/material.dart';
import 'item_atendimento.dart';

// Dados para os contadores
Stream<Map<String, int>> criarStreamContadores() {
  return Stream.value({
    'hoje': 3,
    'concluidos': 1,
  });
}

// Dados para o card de próximo atendimento
Stream<Map<String, String>?> criarStreamProximoAtendimento() {
  return Stream<Map<String, String>?>.value({
    'horario': '14:00',
    'paciente': 'Maria Silva',
    'local': 'Clínica Saúde - Sala 3',
    'descricao': 'Consulta - 60 min',
  });
}

// dados para a lista da agenda de hoje
List<Widget> atendimentosHoje() {
  return [
    ItemAtendimento(
      nome: 'Ana Carolina',
      horario: '10:00',
      local: 'Clínica Saúde - Sala 3',
      concluido: true,
      onTap: () {},
    ),
    ItemAtendimento(
      nome: 'Maria Silva',
      horario: '14:00',
      local: 'Clínica Saúde - Sala 3',
      concluido: false,
      onTap: () {},
    ),
    ItemAtendimento(
      nome: 'João Pedro',
      horario: '16:00',
      local: 'Clínica Multicare - Sala 2',
      concluido: false,
      onTap: () {},
    ),
    ItemAtendimento(
      nome: 'João Pedro',
      horario: '16:00',
      local: 'Clínica Multicare - Sala 2',
      concluido: false,
      onTap: () {},
    ),
  ];
}