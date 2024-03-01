import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/home_screen.dart';

class CustomNavigationBar extends StatelessWidget {
  const CustomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    final navegacionModel = Provider.of<NavegacionModel>(context);

    return BottomNavigationBar(
        currentIndex: navegacionModel.paginaActual,
        onTap: (i) => navegacionModel.paginaActual = i,
        selectedItemColor: const Color(0xffff8965),
        backgroundColor: const Color(0xff172437),
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.data_object_outlined), label: 'Datos'),
          BottomNavigationBarItem(
              icon: Icon(Icons.contactless_outlined), label: 'Control'),
          BottomNavigationBarItem(
              icon: Icon(Icons.supervised_user_circle_outlined),
              label: 'Mi perfil'),
        ]);
  }
}
