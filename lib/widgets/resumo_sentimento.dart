import 'package:flutter/material.dart';
import 'package:sentiments/models/new_model.dart';

class SentimentoResumoLinha extends StatelessWidget {
  final ResumoSentimentos? resumo;
  SentimentoResumoLinha({super.key, required this.resumo});

  final Map<String, Color> cores = {
    'positivo': Colors.green,
    'negativo': Colors.red,
    'neutro': Colors.grey,
  };
  @override
  Widget build(BuildContext context) {
    if (resumo == null) return const SizedBox.shrink();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildSentiment(
          Icons.sentiment_satisfied_alt,
          resumo?.positivo ?? 0,
          'Positivo',
        ),
        _buildSentiment(
          Icons.sentiment_very_dissatisfied,
          resumo?.negativo ?? 0,
          'Negativo',
        ),
        _buildSentiment(
          Icons.sentiment_neutral,
          resumo?.neutro ?? 0,
          'Neutro',
        )
      ],
    );
  }

  Widget _buildSentiment(
    IconData icon,
    int quantity,
    String tipo,
  ) {
    return Column(
      children: [
        Icon(
          icon,
          size: 40,
          color: cores[tipo.toLowerCase()],
        ),
        const SizedBox(height: 4),
        Text(
          (quantity).toString(),
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Text(
          tipo.toUpperCase(),
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }
}
