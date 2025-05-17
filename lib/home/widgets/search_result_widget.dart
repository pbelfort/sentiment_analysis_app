import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../controllers/home_page_controller.dart';
import '../../widgets/news_screen.dart';
import '../../widgets/resumo_sentimento.dart';
import '../../widgets/top_palavras_widget.dart';

class SearchResult extends StatelessWidget {
  final TextEditingController termoController;
  final HomePageController controller;

  const SearchResult({
    super.key,
    required this.termoController,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: TextField(
            controller: termoController,
            decoration: InputDecoration(
              labelText: 'Digite um termo de busca',
              suffixIcon: IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {
                  controller.termo = termoController.text.trim();
                  if (controller.termo.length >= 2) {
                    controller.buscarNoticias(controller.termo);
                  }
                },
              ),
            ),
            onSubmitted: (value) {
              if (value.trim().length >= 2) {
                controller.buscarNoticias(value.trim());
              }
            },
          ),
        ),
        const SizedBox(height: 8),
        if (controller.erro.isNotEmpty)
          Text(
            controller.erro,
            style: const TextStyle(color: Colors.red),
          )
        else if (controller.noticias.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 80),
            child: Column(
              children: [
                const Text('Nenhum resultado.'),
                Lottie.asset(
                  'assets/animations/empty_state.json',
                  width: 250,
                  height: 250,
                ),
              ],
            ),
          )
        else
          Column(
            children: [
              const SizedBox(height: 8),
              Text(
                'Resumo dos sentimentos "${controller.termo}"',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 22),
              SentimentoResumoLinha(resumo: controller.resumoSentimento),
              const SizedBox(height: 32),
              TopPalavrasWidget(topPalavras: controller.topPalavras),
              const SizedBox(height: 32),
              Center(
                child: ElevatedButton(
                  child: const Text('Ver Notícias'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NewsPage(
                          noticias: controller.noticias,
                          topicos: controller.topicos,
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
      ],
    );
  }
}
