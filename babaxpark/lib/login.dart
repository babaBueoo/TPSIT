// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'homePage.dart';
import 'register.dart';
import 'services/sessione_utente.dart';
import 'services/api_service.dart';
import 'widgets/custom_text_field.dart';
import 'widgets/custom_button.dart';
import 'widgets/header_text.dart';

class LoginPage extends StatefulWidget {
  static const Color orange = Color(0xFFFF6B00);
  static const Color green = Color(0xFF1A7A4A);
  static const Color black = Color(0xFF0D0D0D);

  @override
  State<LoginPage> createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> doLogin() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Inserisci email e password'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      final utente = await ApiService().login(emailController.text, passwordController.text);
      if (utente != null) {
        // Salviamo i dati reali trovati nel database
        SessioneUtente().login(
          utente['nome'] ?? utente['username'] ?? "Utente", 
          utente['email'], 
          utente['targa'] ?? "AB123CD"
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => homePagePage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Credenziali errate!'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Errore connessione: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: LoginPage.black,
        body: Container(
          margin: EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              HeaderText(
                title: "Bentornà more",
                subtitle: "te go za visto da ste parti",
                titleColor: LoginPage.orange,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CustomTextField(
                    controller: emailController,
                    hintText: "Email",
                    icon: Icons.person,
                    keyboardType: TextInputType.emailAddress,
                    iconColor: LoginPage.orange,
                  ),
                  SizedBox(height: 10),
                  CustomTextField(
                    controller: passwordController,
                    hintText: "Password",
                    icon: Icons.password,
                    isObscure: true,
                    iconColor: LoginPage.orange,
                  ),
                  SizedBox(height: 30),
                  CustomButton(
                    text: "Login",
                    onPressed: doLogin,
                    backgroundColor: LoginPage.green,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "No te ghe un account?",
                    style: TextStyle(color: Colors.white38),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RegisterPage()),
                      );
                    },
                    child: Text(
                      "Registrate",
                      style: TextStyle(color: LoginPage.orange),
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