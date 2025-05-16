import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sentiments/resumo_sentimento.dart';
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'top_palavras_widget.dart';

void main() {
  runApp(const MaterialApp(
    home: NoticiasPage(),
    debugShowCheckedModeBanner: false,
  ));
}

class NoticiasPage extends StatefulWidget {
  const NoticiasPage({super.key});

  @override
  _NoticiasPageState createState() => _NoticiasPageState();
}

class _NoticiasPageState extends State<NoticiasPage> {
  final TextEditingController _termoController = TextEditingController();
  List<dynamic> _noticias = [];
  List<dynamic> _topPalavras = [];
  Map<String, dynamic> _resumoSentimento = {};

  bool _carregando = false;
  String _erro = '';

  Future<void> buscarNoticias(String termo) async {
    setState(() {
      _carregando = true;
      _erro = '';
      _noticias = [];
      _topPalavras = [];
      _resumoSentimento = {};
    });

    try {
      final response = await http.get(
        Uri.parse(
            'https://sentiment-analysis-p7la.onrender.com/noticias?termo=$termo'),
      );

      if (response.statusCode == 200) {
        final dados = json.decode(response.body);
        setState(() {
          _noticias = dados['noticias'] ?? [];
          _topPalavras = dados['top_palavras'] ?? [];
          _resumoSentimento = dados['resumo_sentimentos'] ?? {};
        });
      } else {
        setState(() {
          _erro = 'Erro ao buscar notícias.';
        });
      }
    } catch (e) {
      setState(() {
        _erro = 'Erro inesperado: $e';
      });
    } finally {
      setState(() {
        _carregando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Busca de Notícias')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: _carregando
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  TextField(
                    controller: _termoController,
                    decoration: InputDecoration(
                      labelText: 'Digite um termo de busca',
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () {
                          final termo = _termoController.text.trim();
                          if (termo.length >= 2) {
                            buscarNoticias(termo);
                          }
                        },
                      ),
                    ),
                    onSubmitted: (value) {
                      if (value.trim().length >= 2) {
                        buscarNoticias(value.trim());
                      }
                    },
                  ),
                  const SizedBox(height: 8),
                  if (_erro.isNotEmpty)
                    Text(_erro, style: const TextStyle(color: Colors.red))
                  else if (_noticias.isEmpty)
                    const Text('Nenhuma notícia carregada.')
                  else
                    Expanded(
                      child: ListView.builder(
                        itemCount: _noticias.length,
                        itemBuilder: (context, index) {
                          final noticia = _noticias[index];
                          return Column(
                            children: [
                              if (index == 0) ...[
                                TopPalavrasWidget(
                                  topPalavras: _topPalavras,
                                ),
                                const SizedBox(height: 16),
                                SentimentoResumoLinha(
                                    resumo: _resumoSentimento),
                                const SizedBox(height: 16),
                              ],
                              Card(
                                elevation: 3,
                                child: ListTile(
                                  title:
                                      Text(noticia['titulo'] ?? 'Sem título'),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        noticia['descricao'] ?? '',
                                        maxLines:
                                            3, // número de linhas visíveis
                                        overflow: TextOverflow
                                            .ellipsis, // adiciona "..." no final
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                              'Sentimento: ${noticia['sentimento']}',
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                          Align(
                                            alignment: Alignment.centerRight,
                                            child: TextButton(
                                              onPressed: () =>
                                                  _abrirLink(noticia['link']),
                                              child: const Text('Saiba mais'),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  onTap: () {
                                    final link = noticia['link'];
                                    if (link != null) {
                                      showDialog(
                                        context: context,
                                        builder: (_) => AlertDialog(
                                          title: const Text('Link da notícia'),
                                          content: Text(link),
                                          actions: [
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                              child: const Text('Fechar'),
                                            ),
                                          ],
                                        ),
                                      );
                                    }
                                  },
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                ],
              ),
      ),
    );
  }
}

void _abrirLink(String url) async {
  final uri = Uri.parse(url);

  await launchUrl(uri);
}
