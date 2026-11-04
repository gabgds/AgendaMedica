import 'package:flutter/material.dart';

import 'confirmacao_modal.dart';
import 'modal_formulario.dart';

Future<DateTime?> abrirSeletorData({
  required BuildContext context,
  required DateTime initialDate,
  required DateTime firstDate,
  required DateTime lastDate,
  DatePickerMode initialDatePickerMode = DatePickerMode.day,
  String helpText = 'Selecione a data',
  String cancelText = 'Cancelar',
  String confirmText = 'Selecionar',
}) {
  return abrirModalFormulario<DateTime>(
    context,
    builder: (context) => _SeletorData(
      inicial: initialDate,
      primeira: firstDate,
      ultima: lastDate,
      modo: initialDatePickerMode,
      titulo: helpText,
      textoCancelar: cancelText,
      textoConfirmar: confirmText,
    ),
  );
}

class _SeletorData extends StatefulWidget {
  const _SeletorData({
    required this.inicial,
    required this.primeira,
    required this.ultima,
    required this.modo,
    required this.titulo,
    required this.textoCancelar,
    required this.textoConfirmar,
  });

  final DateTime inicial;
  final DateTime primeira;
  final DateTime ultima;
  final DatePickerMode modo;
  final String titulo;
  final String textoCancelar;
  final String textoConfirmar;

  @override
  State<_SeletorData> createState() => _SeletorDataState();
}

class _SeletorDataState extends State<_SeletorData> {
  late DateTime data = DateUtils.dateOnly(widget.inicial);

  @override
  Widget build(BuildContext context) {
    return ModalFormulario(
      titulo: widget.titulo,
      conteudo: CalendarDatePicker(
        initialDate: data,
        firstDate: widget.primeira,
        lastDate: widget.ultima,
        initialCalendarMode: widget.modo,
        onDateChanged: (novaData) => setState(() => data = novaData),
      ),
      rodape: AcoesEtapaModal(
        textoCancelar: widget.textoCancelar,
        textoConfirmar: widget.textoConfirmar,
        aoCancelar: () => fecharEtapaModal(context),
        aoConfirmar: () => fecharEtapaModal(context, data),
      ),
    );
  }
}

Future<TimeOfDay?> abrirSeletorHorario({
  required BuildContext context,
  required TimeOfDay initialTime,
  String helpText = 'Selecione o horário',
  String cancelText = 'Cancelar',
  String confirmText = 'Selecionar',
  String hourLabelText = 'Hora',
  String minuteLabelText = 'Minuto',
}) {
  return abrirModalFormulario<TimeOfDay>(
    context,
    builder: (context) {
      final media = MediaQuery.of(context);

      return MediaQuery(
        data: media.copyWith(alwaysUse24HourFormat: true),
        child: TimePickerDialog(
          initialTime: initialTime,
          initialEntryMode: TimePickerEntryMode.dial,
          helpText: helpText,
          cancelText: cancelText,
          confirmText: confirmText,
          hourLabelText: hourLabelText,
          minuteLabelText: minuteLabelText,
        ),
      );
    },
  );
}
