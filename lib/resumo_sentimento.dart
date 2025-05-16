import 'package:flutter/material.dart';

class SentimentoResumoLinha extends StatelessWidget {
  final Map<String, dynamic> resumo;

  const SentimentoResumoLinha({super.key, required this.resumo});

  @override
  Widget build(BuildContext context) {
    final Map<String, IconData> icones = {
      'positivo': Icons.sentiment_satisfied_alt,
      'negativo': Icons.sentiment_very_dissatisfied,
      'neutro': Icons.sentiment_neutral,
    };

    final Map<String, Color> cores = {
      'positivo': Colors.green,
      'negativo': Colors.red,
      'neutro': Colors.grey,
    };

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: resumo.entries.map((entry) {
        final tipo = entry.key;
        final qtd = entry.value;
        return Column(
          children: [
            Icon(
              icones[tipo],
              size: 40,
              color: cores[tipo],
            ),
            const SizedBox(height: 4),
            Text(
              '$qtd',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              tipo.toUpperCase(),
              style: const TextStyle(fontSize: 12),
            ),
          ],
        );
      }).toList(),
    );
  }
}
