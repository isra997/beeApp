// ignore: file_names
import 'package:app1/Services/login_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../widgets/widgets.dart';
import '../providers/login_form_providers.dart';

// ignore: must_be_immutable
class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xff172437),
        body: SingleChildScrollView(
            child: ChangeNotifierProvider(
          create: (_) => LoginFormProvider(),
          child: _loginForm(
              formKey: _formKey,
              emailController: emailController,
              passwordController: passwordController),
        )));
  }
}

class _loginForm extends StatelessWidget {
  const _loginForm({
    required GlobalKey<FormState> formKey,
    required this.emailController,
    required this.passwordController,
  });

  final TextEditingController emailController;
  final TextEditingController passwordController;

  @override
  Widget build(BuildContext context) {
    final loginFormProvider = Provider.of<LoginFormProvider>(context);
    return Form(
      key: loginFormProvider.formKey,
      child: Column(
        children: [
          Stack(
            children: [
              const HeaderLoginThree(),
              // Positioned(
              //     top: 40,
              //     left: 20,
              //     child: GestureDetector(
              //       onTap: () => Navigator.pop(context),
              //       child: Container(
              //         height: 30,
              //         width: 30,
              //         decoration: BoxDecoration(
              //             shape: BoxShape.circle,
              //             border: Border.all(color: Colors.white)),
              //         child: Icon(Icons.arrow_back_ios_outlined,
              //             size: 22, color: Colors.grey[700]),
              //       ),
              //     )),
              const Positioned(
                  top: 60,
                  right: 80,
                  child:
                      Icon(Icons.trip_origin, color: Colors.white38, size: 35)),
              const Positioned(
                  top: 120,
                  left: 90,
                  child:
                      Icon(Icons.trip_origin, color: Colors.white38, size: 35)),
              Positioned(
                  left: MediaQuery.of(context).size.width * 0.35,
                  top: 130,
                  child: const TextFrave(
                      text: 'Bienvenido',
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold)),
              Positioned(
                  left: MediaQuery.of(context).size.width * 0.34,
                  top: 170,
                  child: const TextFrave(
                      text: 'Inicia sesión para continuar',
                      color: Colors.white,
                      fontSize: 17)),
            ],
          ),
          _TextFieldCustom(
              icon: const Icon(Icons.alternate_email_outlined,
                  color: Colors.grey),
              keyboardType: TextInputType.emailAddress,
              hint: 'Ingresa tu email',
              isPassword: false,
              emailController: emailController,
              passwordController: passwordController),
          const SizedBox(height: 40),
          _TextFieldCustom(
              icon: const Icon(Icons.lock_outline, color: Colors.grey),
              keyboardType: TextInputType.visiblePassword,
              hint: 'Contraseña',
              isPassword: true,
              emailController: emailController,
              passwordController: passwordController),
          const SizedBox(height: 10),
          const SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Container(
              height: 50,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: const Color(0xffEAEFF5),
                  borderRadius: BorderRadius.circular(7.0)),
              child: Center(
                  child: TextButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xffEAEFF5),
                        elevation: 0.0,
                      ),
                      onPressed: loginFormProvider.isLoading
                          ? null
                          : () async {
                              FocusScope.of(context).unfocus();
                              final authService = Provider.of<AuthService>(
                                  context,
                                  listen: false);
                              // Navigator.of(context).pushNamed('home');
                              if (!loginFormProvider.isValidForm() &&
                                  emailController.text.length > 10 &&
                                  passwordController.text.length > 3) return;

                              loginFormProvider.isLoading = true;
                              print(loginFormProvider.email);
                              print(loginFormProvider.password);

                              final String? token =
                                  await authService.signInUser(
                                      email: emailController.text,
                                      password: passwordController.text);
                              if (token == null) {
                                Navigator.pushReplacementNamed(context, 'home');
                              } else {
                                // Mostrar error
                                print(token);
                                loginFormProvider.isLoading = false;
                              }
                            },
                      child: Text(
                        loginFormProvider.isLoading
                            ? 'Espere...'
                            : 'Iniciar sesión',
                        style: GoogleFonts.getFont('Inter',
                            color: Colors.black,
                            fontSize: 17,
                            fontWeight: FontWeight.w500),
                      ))),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const TextFrave(
                  text: 'No tienes una cuenta? ',
                  color: Colors.grey,
                  fontSize: 15),
              GestureDetector(
                  onTap: () => Navigator.of(context).pushNamed('registro'),
                  child: const TextFrave(
                      text: 'Registrate',
                      color: Colors.grey,
                      fontSize: 15,
                      fontWeight: FontWeight.bold))
            ],
          )
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class _TextFieldCustom extends StatelessWidget {
  final String hint;
  final bool isPassword;
  final TextInputType? keyboardType;
  final Icon icon;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  _TextFieldCustom(
      {required this.hint,
      required this.isPassword,
      required this.emailController,
      required this.passwordController,
      required this.icon,
      this.keyboardType});

  @override
  Widget build(BuildContext context) {
    final loginFormProvider = Provider.of<LoginFormProvider>(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: TextFormField(
          keyboardType: keyboardType,
          controller: isPassword ? passwordController : emailController,
          onChanged: (value) {
            isPassword
                ? loginFormProvider.email = value
                : loginFormProvider.password = value;
          },
          textAlign: TextAlign.center,
          obscureText: isPassword,
          style: const TextStyle(color: Colors.white, fontSize: 18),
          decoration: InputDecoration(
            prefixIcon: icon,
            border: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.white),
                borderRadius: BorderRadius.circular(10.0)),
            enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.white),
                borderRadius: BorderRadius.circular(10.0)),
            labelStyle: const TextStyle(color: Colors.white),
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.grey),
          )),
    );
  }
}
