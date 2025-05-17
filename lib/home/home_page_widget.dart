import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/home_page_controller.dart';
import '../widgets/news_screen.dart';
import '../widgets/resumo_sentimento.dart';
import '../widgets/top_palavras_widget.dart';

class HomePageWidget extends StatelessWidget {
  const HomePageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<HomePageController>(context);
    final termoController = TextEditingController();

    return controller.carregando
        ? const Center(child: CircularProgressIndicator())
        : Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                TextField(
                  controller: termoController,
                  decoration: InputDecoration(
                    labelText: 'Digite um termo de busca',
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () {
                        final termo = termoController.text.trim();
                        if (termo.length >= 2) {
                          controller.buscarNoticias(termo);
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
                const SizedBox(height: 8),
                if (controller.erro.isNotEmpty)
                  Text(controller.erro,
                      style: const TextStyle(color: Colors.red))
                else if (controller.noticias.isEmpty)
                  const Text('Nenhuma notícia carregada.')
                else
                  Expanded(
                    child: ListView(
                      children: [
                        const SizedBox(height: 8),
                        const Text(
                          'Resumo dos sentimentos',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 22),
                        SentimentoResumoLinha(
                            resumo: controller.resumoSentimento),
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
                  ),
              ],
            ),
          );
  }
}
