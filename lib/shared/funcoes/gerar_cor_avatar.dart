import 'package:flutter/material.dart';

Color gerarCorAvatar(String nome) {
  const cores = [
    Color(0xFF880E4F),
    Color(0xFF00695C),
    Color(0xFF283593),
    Color(0xFF9C27B0),
    Color(0xFFAF601A),
    Color(0xFF1B5E20),
    Color(0xFF01579B),
    Color(0xFFB71C1C),
    Color(0xFF6A1B9A),
    Color(0xFF00838F),
    Color(0xFF1976D2),
    Color(0xFF6015EF),
    Color(0xFF008547),
    Color(0xFFD84315),
    Color(0xFFC2185B),
    Color(0xFF00796B),
    Color(0xFF303F9F),
    Color(0xFF7B1FA2),
    Color(0xFFD32F2F),
    Color(0xFF795548),
    Color(0xFF455A64),
    Color(0xFF006064),
    Color(0xFF827717),
    Color(0xFFAD1457),
    Color(0xFF512DA8),
    Color(0xFF1565C0),
    Color(0xFF2E7D32),
    Color(0xFFBF360C),
    Color(0xFF6D4C41),
    Color(0xFF37474F),
  ];

  final soma = nome.trim().toLowerCase().runes.fold<int>(
    0,
        (total, letra) => total + letra,
  );

  return cores[soma % cores.length];
}