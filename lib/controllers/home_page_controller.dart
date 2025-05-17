import 'package:flutter/material.dart';
import 'package:sentiments/models/new_model.dart';
import 'package:sentiments/repositories/news_repository.dart';

class HomePageController with ChangeNotifier {
  final NewsRepository _repository;
  final TextEditingController termoController = TextEditingController();

  List<Noticia> noticias = [];
  List<dynamic> topPalavras = [];
  ResumoSentimentos? resumoSentimento;
  List<Topico> topicos = [];
  bool carregando = false;
  String erro = '';

  HomePageController(this._repository);

  Future<void> buscarNoticias(String termo) async {
    try {
      carregando = true;
      notifyListeners();
      final resultado = await _repository.buscarNoticias(termo);
      noticias = resultado.noticias;
      topPalavras = resultado.topPalavras;
      resumoSentimento = resultado.resumoSentimentos;
      topicos = resultado.topicos;
    } catch (e) {
      erro = e.toString();
    } finally {
      carregando = false;
      notifyListeners();
    }
  }
}
