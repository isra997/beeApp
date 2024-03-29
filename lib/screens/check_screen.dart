import 'package:app1/Services/login_service.dart';
import 'package:app1/screens/home_screen.dart';
import 'package:app1/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CheckAuthScreen extends StatelessWidget {
  const CheckAuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loginService = Provider.of<AuthService>(context);
    return Scaffold(
      body: Center(
        child: FutureBuilder<String>(
          future: loginService.readToken(),
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            if (!snapshot.hasData) return const Text('Espere...');
            if (snapshot.data != '') {
              Future.microtask(() {
                Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                        pageBuilder: (_, __, ___) => const HomeScreen(),
                        transitionDuration: const Duration(seconds: 0)));
              });
            } else {
              Future.microtask(() {
                Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                        pageBuilder: (_, __, ___) => LoginScreen(),
                        transitionDuration: const Duration(seconds: 0)));
              });
            }
            return Container();
          },
        ),
      ),
    );
  }
}
