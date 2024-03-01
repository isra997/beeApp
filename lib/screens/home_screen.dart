import 'package:app1/Services/data_services.dart';
import 'package:app1/screens/screens.dart';
import 'package:app1/widgets/Background.dart';
import 'package:app1/widgets/widgets.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../Services/services.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => NavegacionModel(),
      child: Scaffold(
        body: Stack(
          children: [const Background(), _HomeBody()],
        ),
        bottomNavigationBar: const CustomNavigationBar(),
      ),
    );
  }
}

class _HomeBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const _Paginas();
  }
}

class _Paginas extends StatefulWidget {
  const _Paginas();

  @override
  State<_Paginas> createState() => _PaginasState();
}

class _PaginasState extends State<_Paginas> {
  DateTime? startDate;
  DateTime? endDate;
  final TextEditingController datoController = TextEditingController();

  final TextEditingController onController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final dataService = Provider.of<DataService>(context);
    final navegacionModel = Provider.of<NavegacionModel>(context);
    final authService = Provider.of<AuthService>(context, listen: false);
    String baseUrl = 'http://';
    // int contador = 0;

    // ignore: no_leading_underscores_for_local_identifiers
    Future<void> _selectDate(BuildContext context, bool isStartDate) async {
      final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2022),
        lastDate: DateTime(2030),
      );

      if (pickedDate != null) {
        String nuevaFecha = pickedDate.toString().substring(0, 10);

        // Reemplaza el guion con la barra
        nuevaFecha = nuevaFecha.replaceFirst('-', '/');

        // Reemplaza el segundo guion con la barra
        nuevaFecha = nuevaFecha.replaceFirst('-', '/');
        setState(() {
          if (isStartDate) {
            startDate = pickedDate;
          } else {
            endDate = pickedDate;
          }
        });
        //dataService.loadDataSpecific(startDate: startDate, endDate: endDate);
      }
    }

    // String onStatus = '';
    // String offStatus = '';
    final DateTime dateNow = DateTime.now();
    // bool encendido = false;
    const storage = FlutterSecureStorage();

    if (dataService.isLoading) return const LoadingScreen();
    var buttonStyle = ButtonStyle(
        backgroundColor:
            MaterialStateProperty.all<Color>(const Color(0xffff8965)),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
                side: const BorderSide(color: Color(0xff6ca0e0)))));
    return PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: navegacionModel.pageController,
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                const PageTitle(
                  titulo: 'Registro de Apitoxina',
                  subtitulo:
                      'Datos por usuario\n Ingresa le peso de la apitoxina en miligramos',
                ),
                const SizedBox(
                  height: 5,
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 5),
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Form(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width: 250,
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                controller: datoController,
                                decoration: const InputDecoration(
                                  icon: Icon(FontAwesomeIcons.flask),
                                  hintText: 'Ingrese dato',
                                  labelText: 'Apitoxina en mg',
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Ingrese un dato';
                                  }
                                  return null;
                                },
                                style: const TextStyle(
                                    color: Colors.black, fontSize: 14),
                              ),
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            IconButton(
                                onPressed: () async {
                                  final nombre =
                                      await storage.read(key: 'nombre');
                                  if (datoController.text.isEmpty) {
                                    return;
                                  }
                                  dataService.datos.clear();
                                  navegacionModel.paginaActual = 0;
                                  final String fecha = dateNow
                                      .toString()
                                      .replaceAll('-', '/')
                                      .substring(0, 10);
                                  await FirebaseDatabase.instance
                                      .ref()
                                      .child('data')
                                      .push()
                                      .set({
                                    'dato': double.parse(
                                        double.parse(datoController.text)
                                            .toStringAsFixed(2)),
                                    'fecha': fecha,
                                    'nombre': nombre,
                                  });
                                  dataService.loadDataSpecific();
                                },
                                icon: const Icon(Icons.save, size: 35),
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            const Color(0xffff8965)),
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(18.0),
                                            side: const BorderSide(
                                                color: Color(0xffff8965)))))),
                          ],
                        ),
                        const SizedBox(height: 5),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: buttonStyle,
                      onPressed: () =>
                          _selectDate(context, true), // true for start date
                      child: const Text('Fecha de inicio'),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      style: buttonStyle,
                      onPressed: () =>
                          _selectDate(context, false), // false for end date
                      child: const Text('Fecha de fin'),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      style: buttonStyle,
                      onPressed: () {
                        dataService.datosPersonalizados.clear();
                        dataService.loadDataSpecific(
                            startDate: startDate, endDate: endDate);
                        print('Start Date: $startDate, End Date: $endDate');
                      },
                      child: const Text('Cargar datos'),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 3,
                ),
                SizedBox(
                  width: double.infinity,
                  height: 300,
                  child: ListView.builder(
                      itemCount: dataService.datosPersonalizados.length,
                      itemBuilder: (BuildContext context, int index) =>
                          GestureDetector(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 3),
                              margin: const EdgeInsets.symmetric(vertical: 3),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.7),
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: Row(
                                children: [
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    index.toString(),
                                    style: const TextStyle(
                                      fontSize: 15,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 13,
                                  ),
                                  Text(
                                      dataService.datosPersonalizados[index]
                                              .nombre ??
                                          '',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      )),
                                  const SizedBox(
                                    width: 18,
                                  ),
                                  Text(
                                    '${dataService.datosPersonalizados[index].fecha} ',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 13,
                                  ),
                                  Text(
                                    'Dato: ${dataService.datosPersonalizados[index].dato} mg',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ),
                            ),
                          )),
                ),
                const SizedBox(
                  height: 25,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xffff8965),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Text('Suma: ${dataService.sumaFinal} mg',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          )),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xffff8965),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Text('Promedio: ${dataService.promFinal} mg',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          )),
                    ),
                  ],
                )
              ],
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                const PageTitle(
                  titulo: 'Bienvenido',
                  subtitulo: 'Desde aquí puedes controlar el microcontrolador',
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 145,
                    ),
                    Text(
                      navegacionModel.encendido
                          ? 'INICIADO ${navegacionModel._contador}'
                          : 'DETENIDO',
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () async {
                            navegacionModel.contador = 10;
                            // onStatus = storage.read(key: 'off').toString();
                            if (onController.text.isEmpty) {
                              final snackBar = SnackBar(
                                content: const Text('Ingresa una direccion IP'),
                                action: SnackBarAction(
                                  label: 'OK',
                                  onPressed: () {
                                    // Some code to undo the change.
                                  },
                                ),
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                              return;
                            }
                            try {
                              navegacionModel.encendido = true;
                              final url =
                                  Uri.parse("$baseUrl${onController.text}/on");
                              final response = await http.get(url);

                              final snackBar = SnackBar(
                                backgroundColor: const Color(0xff35485f),
                                content: Text(response.body.toString()),
                                action: SnackBarAction(
                                  label: 'OK',
                                  onPressed: () {
                                    // Some code to undo the change.
                                  },
                                ),
                              );

                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                              for (int i = 0; i < 10; i++) {
                                navegacionModel.contador = 9 - i;
                                await Future.delayed(
                                    const Duration(seconds: 1));
                              }
                              navegacionModel.encendido = false;
                            } catch (e) {
                              final snackBar = SnackBar(
                                backgroundColor: const Color(0xff35485f),
                                content: const Text(
                                    'El servidor no responde, revisa la IP'),
                                action: SnackBarAction(
                                  label: 'OK',
                                  onPressed: () {
                                    // Algun código para deshacer el cambio.
                                  },
                                ),
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                              print('error: $e');
                            }
                          },
                          child: navegacionModel._encendido
                              ? const Icon(
                                  Icons.play_circle_outline,
                                  size: 100,
                                  color: Colors.white,
                                )
                              : const Icon(
                                  Icons.play_circle_outline_outlined,
                                  size: 100,
                                  color: Colors.white,
                                ),
                        ),
                        InkWell(
                          onTap: () async {
                            navegacionModel.encendido = false;
                            if (onController.text.isEmpty) {
                              final snackBar = SnackBar(
                                backgroundColor: const Color(0xff35485f),
                                content: const Text('Ingresa una direccion IP'),
                                action: SnackBarAction(
                                  label: 'OK',
                                  onPressed: () {
                                    // Some code to undo the change.
                                  },
                                ),
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                              return;
                            }

                            try {
                              final url = Uri.parse(
                                  "$baseUrl${onController.text}/update");
                              final response = await http.get(url);
                              final snackBar = SnackBar(
                                backgroundColor: const Color(0xff35485f),
                                content: Text(response.body.toString()),
                                action: SnackBarAction(
                                  label: 'OK',
                                  onPressed: () {
                                    // Some code to undo the change.
                                  },
                                ),
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                              // navegacionModel.encendido = true;
                            } catch (e) {
                              navegacionModel.encendido = false;

                              final snackBar = SnackBar(
                                backgroundColor: const Color(0xff35485f),
                                content: const Text(
                                    'El servidor no responde, revisa la IP'),
                                action: SnackBarAction(
                                  label: 'OK',
                                  onPressed: () {
                                    // Algun código para deshacer el cambio.
                                  },
                                ),
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                              print('error: $e');
                            }
                            // offStatus = storage.read(key: 'on').toString();
                          },
                          child: navegacionModel._encendido
                              ? const Icon(
                                  Icons.stop_circle_outlined,
                                  size: 100,
                                  color: Colors.white,
                                )
                              : const Icon(
                                  Icons.stop_circle_sharp,
                                  size: 100,
                                  color: Colors.white,
                                ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 0),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                width: 250,
                                child: TextFormField(
                                  keyboardType: TextInputType.number,
                                  controller: onController,
                                  decoration: const InputDecoration(
                                    icon: Icon(Icons.offline_bolt),
                                    hintText: '192.168.100.1',
                                    labelText: 'Ingresa la IP',
                                  ),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Ingrese IP';
                                    }
                                    return null;
                                  },
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 14),
                                ),
                              ),
                              const SizedBox(
                                width: 15,
                              ),
                              IconButton(
                                onPressed: () async {
                                  FocusScope.of(context).unfocus();
                                  await storage.write(
                                      key: 'on', value: onController.text);
                                  final currentContext =
                                      context; // Capturar el BuildContext aquí
                                  try {
                                    final url = Uri.parse(
                                        "$baseUrl${onController.text}");
                                    final response = await http.get(url);
                                    final snackBar = SnackBar(
                                      backgroundColor: const Color(0xff35485f),
                                      content: Text(response.body.toString()),
                                      action: SnackBarAction(
                                        label: 'OK',
                                        onPressed: () {
                                          // Some code to undo the change.
                                        },
                                      ),
                                    );
                                    // ignore: use_build_context_synchronously
                                    ScaffoldMessenger.of(currentContext)
                                        .showSnackBar(snackBar);
                                  } catch (e) {
                                    final snackBar = SnackBar(
                                      backgroundColor: const Color(0xff35485f),
                                      content:
                                          const Text("No se pudo conectar"),
                                      action: SnackBarAction(
                                        label: 'OK',
                                        onPressed: () {
                                          // Some code to undo the change.
                                        },
                                      ),
                                    );
                                    // ignore: use_build_context_synchronously
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                  }
                                },
                                icon: const Icon(
                                  Icons.save,
                                  size: 35,
                                  color: Color(0xff172437),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          //Row(
                          //  children: [
                          //    SizedBox(
                          //      width: 250,
                          //      child: TextFormField(
                          //        keyboardType: TextInputType.emailAddress,
                          //        controller: offController,
                          //        decoration: const InputDecoration(
                          //          icon: Icon(Icons.offline_bolt_outlined),
                          //          hintText: '192.168.100.1/off',
                          //          labelText: '192.168.100.1/off',
                          //        ),
                          //        validator: (value) {
                          //          if (value!.isEmpty) {
                          //            return 'Ingrese IP';
                          //          }
                          //          return null;
                          //        },
                          //        style: const TextStyle(
                          //            color: Colors.black, fontSize: 14),
                          //      ),
                          //    ),
                          //    const SizedBox(
                          //      width: 15,
                          //    ),
                          //    IconButton(
                          //      onPressed: () async {
                          //        FocusScope.of(context).unfocus();
                          //        await storage.write(
                          //            key: 'off', value: offController.text);
                          //      },
                          //      icon: const Icon(
                          //        Icons.save,
                          //        size: 35,
                          //        color: Color(0xff172437),
                          //      ),
                          //    ),
                          //  ],
                          //),
                          const SizedBox(height: 5),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                )
              ],
            ),
          ),
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const PageTitle(
                  titulo: 'Mi perfil',
                  subtitulo: 'Configura tu perfil',
                ),
                const SizedBox(
                  height: 150,
                ),
                ElevatedButton(
                  onPressed: () {
                    authService.logout();
                    Navigator.pushReplacementNamed(context, 'login');
                  },
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          const Color(0xffff8965)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side:
                                  const BorderSide(color: Color(0xffff8965))))),
                  child: const Padding(
                    padding: EdgeInsets.all(15),
                    child: Text('Cerrar sesión'),
                  ),
                ),
              ],
            ),
          ),
        ]);
  }
}

class NavegacionModel with ChangeNotifier {
  int _contador = 0;
  bool _encendido = false;
  int _paginaActual = 0;

  final PageController _pageController = PageController();

  int get paginaActual => _paginaActual;
  bool get encendido => _encendido;
  int get contador => _contador;

  set encendido(bool valor) {
    _encendido = valor;
    notifyListeners();
  }

  set contador(int valor) {
    _contador = valor;
    notifyListeners();
  }

  set paginaActual(int valor) {
    _paginaActual = valor;
    _pageController.animateToPage(valor,
        duration: const Duration(milliseconds: 250), curve: Curves.easeOut);
    notifyListeners();
  }

  PageController get pageController => _pageController;
}
