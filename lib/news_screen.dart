import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsPage extends StatelessWidget {
  final List<dynamic> noticias;
  final List<dynamic> topicos;

  const NewsPage({
    super.key,
    required this.noticias,
    required this.topicos,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notícias')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: noticias.length,
          itemBuilder: (context, index) {
            final noticia = noticias[index];
            final palavras = topicos[index]['palavras'] as List<dynamic>;
            return Card(
              elevation: 3,
              child: ListTile(
                title: Text(noticia['titulo'] ?? 'Sem título'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      noticia['descricao'] ?? '',
                      maxLines: 3, // número de linhas visíveis
                      overflow:
                          TextOverflow.ellipsis, // adiciona "..." no final
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            getSentimentoIcon(noticia['sentimento']),
                          ],
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () => _abrirLink(noticia['link']),
                            child: const Text('Saiba mais'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text('Tópicos da Notícia'),
                      content: Container(
                        constraints: const BoxConstraints(maxHeight: 500),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 12),
                              // Chips com palavras
                              Wrap(
                                spacing: 6,
                                runSpacing: -4,
                                children: palavras.map<Widget>((p) {
                                  final valor = p[1];
                                  Color cor;
                                  if (valor >= 0.03) {
                                    cor = Colors.green.shade300;
                                  } else if (valor >= 0.015) {
                                    cor = Colors.orange.shade300;
                                  } else {
                                    cor = Colors.grey.shade300;
                                  }

                                  return Chip(
                                    label: Column(
                                      children: [
                                        Text(p[0]),
                                        Text(
                                            '${(valor * 100).toStringAsFixed(2)}%'),
                                      ],
                                    ),
                                    backgroundColor: cor,
                                    labelStyle: const TextStyle(fontSize: 12),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 4),
                                  );
                                }).toList(),
                              ),
                              const SizedBox(height: 12), // Legenda
                              const Text(
                                'Legenda:',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Container(
                                    width: 16,
                                    height: 16,
                                    color: Colors.green.shade300,
                                  ),
                                  const SizedBox(width: 4),
                                  const Text('Mais representativa'),
                                  const SizedBox(width: 12),
                                ],
                              ),
                              Row(
                                children: [
                                  Container(
                                      width: 16,
                                      height: 16,
                                      color: Colors.orange.shade300),
                                  const SizedBox(width: 4),
                                  const Text('Representatividade média'),
                                  const SizedBox(width: 12),
                                ],
                              ),
                              Row(
                                children: [
                                  Container(
                                      width: 16,
                                      height: 16,
                                      color: Colors.grey.shade300),
                                  const SizedBox(width: 4),
                                  const Text('Menos representativa'),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Fechar'),
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }

  void _abrirLink(String url) async {
    final uri = Uri.parse(url);
    await launchUrl(uri);
  }

  Color corPorSentimento(String sentimento) {
    switch (sentimento.toLowerCase()) {
      case 'positivo':
        return Colors.green;
      case 'negativo':
        return Colors.red;
      case 'neutro':
        return Colors.grey;
      default:
        return Colors.black;
    }
  }

  Icon getSentimentoIcon(String sentimento) {
    switch (sentimento.toLowerCase()) {
      case 'positivo':
        return const Icon(Icons.thumb_up, color: Colors.green);
      case 'negativo':
        return const Icon(Icons.thumb_down, color: Colors.red);
      case 'neutro':
        return const Icon(Icons.thumbs_up_down, color: Colors.grey);
      default:
        return const Icon(Icons.help_outline, color: Colors.black);
    }
  }
}
