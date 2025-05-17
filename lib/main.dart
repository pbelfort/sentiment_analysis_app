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
      child: MaterialApp(
        home: const NoticiasPage(),
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.orangeAccent,
            brightness: Brightness.light,
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.orangeAccent,
            foregroundColor: Colors.white,
          ),
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.orangeAccent),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orangeAccent,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ),
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
      appBar: AppBar(
          title: const Text(
        'Busca de Notícias',
        style: TextStyle(color: Colors.black),
      )),
      body: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: HomePageWidget()),
    );
  }
}
