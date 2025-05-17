import 'package:flutter/material.dart';

class TopPalavrasWidget extends StatelessWidget {
  final List<dynamic> topPalavras;

  const TopPalavrasWidget({super.key, required this.topPalavras});

  @override
  Widget build(BuildContext context) {
    // Pega o valor máximo para escalar as barras proporcionalmente
    final int maxValue =
        topPalavras.map((e) => e[1] as int).reduce((a, b) => a > b ? a : b);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Top Palavras',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ...topPalavras.map((palavra) {
          final String texto = palavra[0];
          final int valor = palavra[1];
          final double porcentagem = valor / maxValue;

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                SizedBox(width: 80, child: Text(texto)),
                Expanded(
                  child: Stack(
                    children: [
                      Container(
                        height: 20,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      FractionallySizedBox(
                        widthFactor: porcentagem,
                        child: Container(
                          height: 20,
                          decoration: BoxDecoration(
                            color: Colors.deepOrange,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Text('$valor'),
              ],
            ),
          );
        }),
      ],
    );
  }
}
