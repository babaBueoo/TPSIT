// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'login.dart';
import 'services/api_service.dart';
import 'package:bcrypt/bcrypt.dart';
import 'widgets/custom_text_field.dart';
import 'widgets/custom_button.dart';
import 'widgets/header_text.dart';

class RegisterPage extends StatefulWidget {
  static const Color orange = Color(0xFFFF6B00);
  static const Color green = Color(0xFF1A7A4A);
  static const Color black = Color(0xFF0D0D0D);

  @override
  State<RegisterPage> createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void doRegister() async {
    if (usernameController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Compila tutti i campi'),
          backgroundColor: RegisterPage.orange,
        ),
      );
      return;
    }

    try {
      final hashedPassword = BCrypt.hashpw(passwordController.text, BCrypt.gensalt());

      await ApiService().registraUtente({
        "id": DateTime.now().millisecondsSinceEpoch.toString(),
        "username": usernameController.text,
        "email": emailController.text,
        "password": hashedPassword,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Registrazione completata! Accedi ora.'),
          backgroundColor: RegisterPage.green,
        ),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Errore durante la registrazione: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: RegisterPage.black,
        body: Container(
          margin: EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              HeaderText(
                title: "Benvenuto",
                subtitle: "ti xe novo?",
                titleColor: RegisterPage.orange,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CustomTextField(
                    controller: usernameController,
                    hintText: "Username",
                    icon: Icons.person,
                    iconColor: RegisterPage.orange,
                  ),
                  SizedBox(height: 10),
                  CustomTextField(
                    controller: emailController,
                    hintText: "Email",
                    icon: Icons.email,
                    keyboardType: TextInputType.emailAddress,
                    iconColor: RegisterPage.orange,
                  ),
                  SizedBox(height: 10),
                  CustomTextField(
                    controller: passwordController,
                    hintText: "Password",
                    icon: Icons.password,
                    isObscure: true,
                    iconColor: RegisterPage.orange,
                  ),
                  SizedBox(height: 30),
                  CustomButton(
                    text: "Registrate",
                    onPressed: doRegister,
                    backgroundColor: RegisterPage.green,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Gheto za n'account?",
                    style: TextStyle(color: Colors.white38),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      "Accedi",
                      style: TextStyle(color: RegisterPage.orange),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
