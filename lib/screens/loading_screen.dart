import 'package:app1/widgets/Background.dart';
import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Stack(children: [
        Background(),
        Center(
          child: CircularProgressIndicator(
            color: Colors.indigo,
          ),
        ),
      ]),
    );
  }
}
