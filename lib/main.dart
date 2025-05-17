import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sentiments/resumo_sentimento.dart';
import 'dart:convert';
import 'news_screen.dart';
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
  NoticiasPageState createState() => NoticiasPageState();
}

class NoticiasPageState extends State<NoticiasPage> {
  final TextEditingController _termoController = TextEditingController();
  List<dynamic> _noticias = [];
  List<dynamic> _topPalavras = [];
  Map<String, dynamic> _resumoSentimento = {};
  List<dynamic> _topicos = [];

  bool _carregando = false;
  String _erro = '';

  Future<void> buscarNoticias(String termo) async {
    setState(() {
      _carregando = true;
      _erro = '';
      _noticias = [];
      _topPalavras = [];
      _resumoSentimento = {};
      _topicos = [];
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
          _topicos = dados['topicos'] ?? [];
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
                          SentimentoResumoLinha(resumo: _resumoSentimento),
                          const SizedBox(height: 32),
                          TopPalavrasWidget(
                            topPalavras: _topPalavras,
                          ),
                          const SizedBox(height: 32),
                          Center(
                            child: ElevatedButton(
                                child: const Text('Ver Notícias'),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => NewsPage(
                                        noticias: _noticias,
                                        topicos: _topicos,
                                      ),
                                    ),
                                  );
                                }),
                          ),
                          const SizedBox(height: 32),
                        ],
                      ),
                    ),
                ],
              ),
      ),
    );
  }
}
