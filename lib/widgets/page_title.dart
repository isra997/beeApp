import 'package:flutter/material.dart';

class PageTitle extends StatelessWidget {
  final String titulo;
  final String subtitulo;
  const PageTitle({super.key, required this.titulo, required this.subtitulo});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 25),
            Text(titulo,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Text(subtitulo,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w300)),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
