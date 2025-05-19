import 'dart:async';
import 'dart:convert';
import 'dart:io';
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
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/noticias?termo=$termo'))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final Map<String, dynamic> dados = json.decode(response.body);
        return NewsModel.fromJson(dados);
      } else {
        throw HttpException(
            'Erro ao buscar notícias. Código: ${response.statusCode}');
      }
    } on SocketException {
      throw Exception('Falha na conexão. Verifique sua internet.');
    } on TimeoutException {
      throw Exception(
          'Tempo de resposta excedido. Tente novamente mais tarde.');
    } on HttpException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception('Erro inesperado: $e');
    }
  }
}
