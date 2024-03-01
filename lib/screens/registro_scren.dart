import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../widgets/widgets.dart';
import '../Services/login_service.dart';
import '../providers/login_form_providers.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

enum FieldType { email, password, name, telefono }

class RegistroScreen extends StatelessWidget {
  RegistroScreen({super.key});

  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController telefonoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff172437),
      body: SingleChildScrollView(
          child: ChangeNotifierProvider(
        create: (_) => LoginFormProvider(),
        child: _loginForm(
            formKey: _formKey,
            nameController: nameController,
            emailController: emailController,
            telefonoController: telefonoController,
            passwordController: passwordController),
      )),
    );
  }
}

class _loginForm extends StatelessWidget {
  const _loginForm({
    required GlobalKey<FormState> formKey,
    required this.nameController,
    required this.emailController,
    required this.telefonoController,
    required this.passwordController,
  });

  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController telefonoController;
  final TextEditingController passwordController;
  final storage = const FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    final loginFormProvider = Provider.of<LoginFormProvider>(context);
    return Form(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      key: loginFormProvider.formKey,
      child: Column(
        children: [
          Stack(
            children: [
              const HeaderSignUpThree(),
              Positioned(
                  top: 40,
                  left: 20,
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white)),
                      child: Icon(Icons.arrow_back_ios_outlined,
                          size: 22, color: Colors.grey[700]),
                    ),
                  )),
              const Positioned(
                  top: 40,
                  right: 80,
                  child:
                      Icon(Icons.trip_origin, color: Colors.white38, size: 35)),
              const Positioned(
                  top: 90,
                  left: 60,
                  child:
                      Icon(Icons.trip_origin, color: Colors.white38, size: 35)),
              const Positioned(
                  top: 165,
                  left: 60,
                  child: TextFrave(
                      text: 'Crea una cuenta',
                      color: Colors.white,
                      fontSize: 35,
                      fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 30),
          _TextFieldCustom(
            hint: 'Nombre y apellido',
            isPassword: false,
            fieldType: FieldType.name,
            controller: nameController,
            icon: Icon(Icons.person, color: Colors.grey[700]!),
            keyboardType: TextInputType.name,
          ),
          const SizedBox(height: 20),
          _TextFieldCustom(
            hint: 'Email',
            isPassword: false,
            fieldType: FieldType.email,
            controller: emailController,
            icon: Icon(Icons.alternate_email, color: Colors.grey[700]!),
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 20),
          _TextFieldCustom(
            hint: 'Número de teléfono',
            isPassword: false,
            fieldType: FieldType.telefono,
            controller: telefonoController,
            icon: Icon(Icons.phone, color: Colors.grey[700]!),
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 20),
          _TextFieldCustom(
            hint: 'Contraseña',
            isPassword: true,
            fieldType: FieldType.password,
            controller: passwordController,
            icon: Icon(Icons.password_outlined, color: Colors.grey[700]!),
            keyboardType: TextInputType.visiblePassword,
          ),
          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: InkWell(
              onTap: () => Navigator.of(context).pushNamed('verificacion'),
              child: Container(
                height: 50,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: const Color(0xffEAEFF5),
                    borderRadius: BorderRadius.circular(7.0)),
                child: TextButton(
                    onPressed: loginFormProvider.isLoading
                        ? null
                        : () async {
                            FocusScope.of(context).unfocus();
                            storage.write(
                                key: 'nombre', value: nameController.text);
                            final authService = Provider.of<AuthService>(
                                context,
                                listen: false);
                            if (!loginFormProvider.isValidForm()) return;

                            loginFormProvider.isLoading = true;

                            final String? errorMessage =
                                await authService.createUser(
                                    email: emailController.text,
                                    password: passwordController.text);
                            if (errorMessage == null) {
                              Navigator.pushReplacementNamed(context, 'home');
                            } else {
                              // Mostrar error
                              print(errorMessage);
                              loginFormProvider.isLoading = false;
                            }
                          },
                    child: Text(
                      loginFormProvider.isLoading ? 'Espere...' : 'Registrarse',
                      style: GoogleFonts.getFont('Inter',
                          color: Colors.black,
                          fontSize: 17,
                          fontWeight: FontWeight.w500),
                    )),
              ),
            ),
          ),
          const SizedBox(height: 25),
          const TextFrave(text: 'O', color: Colors.grey, fontSize: 15),
          const SizedBox(height: 25),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const TextFrave(
                  text: 'Ya tienes una cuenta? ',
                  color: Colors.grey,
                  fontSize: 15),
              GestureDetector(
                  onTap: () => Navigator.of(context).pushNamed('login'),
                  child: const TextFrave(
                      text: 'Ingresar',
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
  //decoration
  final TextInputType? keyboardType;
  final Icon icon;

  final String hint;
  final bool isPassword;
  final FieldType fieldType;
  TextEditingController controller;

  _TextFieldCustom(
      {required this.fieldType,
      required this.hint,
      required this.isPassword,
      required this.controller,
      required this.icon,
      this.keyboardType}) {
    if (fieldType == FieldType.email) {
      controller = controller;
    } else if (fieldType == FieldType.password) {
      controller = controller;
    } else if (fieldType == FieldType.name) {
      controller = controller;
    } else if (fieldType == FieldType.telefono) {
      controller = controller;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: TextFormField(
        keyboardType: keyboardType,
        autocorrect: false,
        textAlign: TextAlign.center,
        controller: controller,
        obscureText: isPassword,
        style: const TextStyle(color: Colors.white, fontSize: 17),
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
        ),
      ),
    );
  }
}
