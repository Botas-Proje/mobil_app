import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mpaiapp/screens/products.dart';
import 'package:mpaiapp/services/authenticationService.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _key = GlobalKey<FormState>();

  final AuthenticationServices _auth = AuthenticationServices();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("BOTAŞ"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: Center(
                child: SizedBox(
                  width: MediaQuery.sizeOf(context).width * 0.6,
                  child: Image.asset(
                    'assets/images/botos_clear.png',
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            CupertinoTextFormFieldRow(
              padding: EdgeInsets.symmetric(horizontal: 12),
              placeholder: "E-mail",
              controller: emailController,
              placeholderStyle:
                  const TextStyle(color: Color.fromARGB(255, 111, 111, 112)),
              style: TextStyle(color: Colors.black54),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.redAccent),
                  color: Color.fromARGB(255, 243, 242, 242),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 10.0,
                    )
                  ]),
            ),
            const SizedBox(height: 8),
            CupertinoTextFormFieldRow(
              padding: EdgeInsets.symmetric(horizontal: 12),
              placeholder: "Şifre",
              obscureText: true,
              autocorrect: false,
              controller: passwordController,
              placeholderStyle:
                  const TextStyle(color: Color.fromARGB(255, 111, 111, 112)),
              style: TextStyle(color: Colors.black54),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.redAccent),
                  color: Color.fromARGB(255, 243, 242, 242),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 10.0,
                    )
                  ]),
            ),
            const SizedBox(height: 8),
            Center(
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32.0)),
                  ),
                  child: Text("Giriş yap"),
                  onPressed: () {
                    print("butona basıldı");
                    _signInUser();
                  }),
            )
          ],
        ),
      ),
    );
  }

  void _signInUser() async {
    print("Buraya geldi.");
    final authResult = await _auth.loginUser(
      emailController.text.toString(),
      passwordController.text.toString(),
    );

    if (authResult == null) {
      print("Sign in error.");
      _alertdialogBuilder();
    }

    ///
    else {
      emailController.clear();
      passwordController.clear();

      if (mounted) {
        Navigator.pushNamed(context, "/products");
      }
    }
  }

  void _alertdialogBuilder() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Sizi bulamadık!'),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 5,
              ),
              Text("Mailinizin ve şifrenizin doğruluğunu kontrol ediniz.")
            ],
          ),
          actions: [
            TextButton(
              child: const Text('Çıkış'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
