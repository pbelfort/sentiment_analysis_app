import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sentiments/repositories/news_repository.dart';

import 'controllers/home_page_controller.dart';
import 'home/home_page_widget.dart';

void main() {
  final repository = NewsRepository();
  runApp(
    ChangeNotifierProvider(
      create: (_) => HomePageController(repository),
      child: const MaterialApp(
        home: NoticiasPage(),
        debugShowCheckedModeBanner: false,
      ),
    ),
  );
}

class NoticiasPage extends StatefulWidget {
  const NoticiasPage({super.key});

  @override
  NoticiasPageState createState() => NoticiasPageState();
}

class NoticiasPageState extends State<NoticiasPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Busca de Notícias')),
      body: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: HomePageWidget()),
    );
  }
}
