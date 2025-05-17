import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:sentiments/home/widgets/search_result_widget.dart';
import '../controllers/home_page_controller.dart';

class HomePageWidget extends StatelessWidget {
  const HomePageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<HomePageController>(context);
    final termoController = TextEditingController();

    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: controller.carregando
            ? _buildSearchLoading(context)
            : SearchResult(
                termoController: termoController,
                controller: controller,
              ));
  }

  Widget _buildSearchLoading(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 150,
      ),
      child: Lottie.asset(
        'assets/animations/searching.json',
        width: 350,
        height: 350,
      ),
    );
  }
}
