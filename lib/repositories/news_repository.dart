import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sentiments/models/new_model.dart';

abstract class INewsRepository {
  Future<NewsModel> buscarNoticias(String termo);
}

class NewsRepository implements INewsRepository {
  final String baseUrl;

  NewsRepository(
      {this.baseUrl = 'https://sentiment-analysis-p7la.onrender.com'});

  @override
  Future<NewsModel> buscarNoticias(String termo) async {
    final response =
        await http.get(Uri.parse('$baseUrl/noticias?termo=$termo'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> dados = json.decode(response.body);
      return NewsModel.fromJson(dados);
    } else {
      throw Exception(
          'Erro ao buscar notícias. Código: ${response.statusCode}');
    }
  }
}
