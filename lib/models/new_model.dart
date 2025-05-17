class NewsModel {
  NewsModel({
    required this.termo,
    required this.quantidade,
    required this.noticias,
    required this.resumoSentimentos,
    required this.topPalavras,
    required this.topicos,
    required this.nextPage,
  });

  final String? termo;
  final int? quantidade;
  final List<Noticia> noticias;
  final ResumoSentimentos? resumoSentimentos;
  final List<dynamic> topPalavras;
  final List<Topico> topicos;
  final String? nextPage;

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(
      termo: json["termo"],
      quantidade: json["quantidade"],
      noticias: json["noticias"] == null
          ? []
          : List<Noticia>.from(
              json["noticias"]?.map((x) => Noticia.fromJson(x))),
      resumoSentimentos: json["resumo_sentimentos"] == null
          ? null
          : ResumoSentimentos.fromJson(json["resumo_sentimentos"]),
      topPalavras: json["top_palavras"] == null
          ? []
          : List<List<dynamic>>.from(json["top_palavras"]?.map(
              (x) => x == null ? [] : List<dynamic>.from(x?.map((x) => x)))),
      topicos: json["topicos"] == null
          ? []
          : List<Topico>.from(json["topicos"]?.map((x) => Topico.fromJson(x))),
      nextPage: json["nextPage"],
    );
  }
}

class Noticia {
  Noticia({
    required this.titulo,
    required this.descricao,
    required this.fonte,
    required this.link,
    required this.sentimento,
  });

  final String? titulo;
  final String? descricao;
  final String? fonte;
  final String? link;
  final String? sentimento;

  factory Noticia.fromJson(Map<String, dynamic> json) {
    return Noticia(
      titulo: json["titulo"],
      descricao: json["descricao"],
      fonte: json["fonte"],
      link: json["link"],
      sentimento: json["sentimento"],
    );
  }
}

class ResumoSentimentos {
  ResumoSentimentos({
    required this.positivo,
    required this.negativo,
    required this.neutro,
  });

  final int? positivo;
  final int? negativo;
  final int? neutro;

  factory ResumoSentimentos.fromJson(Map<String, dynamic> json) {
    return ResumoSentimentos(
      positivo: json["positivo"],
      negativo: json["negativo"],
      neutro: json["neutro"],
    );
  }
}

class Topico {
  Topico({
    required this.topico,
    required this.palavras,
  });

  final int? topico;
  final List<List<dynamic>> palavras;

  factory Topico.fromJson(Map<String, dynamic> json) {
    return Topico(
      topico: json["topico"],
      palavras: json["palavras"] == null
          ? []
          : List<List<dynamic>>.from(json["palavras"]?.map(
              (x) => x == null ? [] : List<dynamic>.from(x?.map((x) => x)))),
    );
  }
}
