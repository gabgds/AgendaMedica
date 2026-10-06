import 'package:flutter/material.dart';

class SeletorDias extends StatelessWidget {
  const SeletorDias({
    super.key,
    required this.dataSelecionada,
    required this.aoSelecionar,
  });

  final DateTime dataSelecionada;
  final ValueChanged<DateTime> aoSelecionar;

  static const verde = Color(0xFF009B95);
  static const dias = ['Dom', 'Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb'];
  static const meses = [
    'Janeiro', 'Fevereiro', 'Março', 'Abril', 'Maio', 'Junho',
    'Julho', 'Agosto', 'Setembro', 'Outubro', 'Novembro', 'Dezembro',
  ];

  Future<void> escolherData(BuildContext context) async {
    final data = await showDatePicker(
      context: context,
      initialDate: dataSelecionada,
      firstDate: DateTime(2026),
      lastDate: DateTime(2150, 12, 31),
      helpText: 'Selecione a data',
      cancelText: 'Cancelar',
      confirmText: 'Selecionar',
    );

    if (data != null) {
      aoSelecionar(data);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextButton(
          onPressed: () => escolherData(context),
          style: TextButton.styleFrom(
            backgroundColor: verde,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            '${meses[dataSelecionada.month - 1]} ${dataSelecionada.year}',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: semana(),
        ),
      ],
    );
  }

  Widget semana() {
    // Domingo é o primeiro dia. DateTime também ajusta viradas de mês e ano.
    final domingo = DateTime(
      dataSelecionada.year,
      dataSelecionada.month,
      dataSelecionada.day - dataSelecionada.weekday % 7,
    );

    return Row(
      children: [
        for (int indice = 0; indice < 7; indice++)
          botaoDia(DateTime(domingo.year, domingo.month, domingo.day + indice)),
      ],
    );
  }

  Widget botaoDia(DateTime data) {
    final selecionado = DateUtils.isSameDay(data, dataSelecionada);

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Material(
        color: selecionado ? verde : const Color(0xFFF4F5FA),
        borderRadius: BorderRadius.circular(10),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => aoSelecionar(data),
          child: Container(
            constraints: const BoxConstraints(minWidth: 43),
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
            child: Column(
              children: [
                Text(
                  dias[data.weekday % 7],
                  style: TextStyle(
                    fontSize: 16,
                    color: selecionado ? Colors.white : Colors.grey,
                  ),
                ),
                Text(
                  '${data.day}',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: selecionado ? Colors.white : const Color(0xFF29363D),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
