import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mpaiapp/screens/checkImageScreen.dart';
import 'package:mpaiapp/screens/imageScreen.dart';
import 'package:mpaiapp/screens/loginScreen.dart';
import 'package:mpaiapp/screens/mainPage.dart';
import 'package:mpaiapp/screens/nullPageScreen.dart';
import 'package:mpaiapp/screens/products.dart';
import 'package:mpaiapp/services/forHttp.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BOTAŞ ODS',
      home: const LoginScreen(),
      theme: ThemeData(
        primaryColor: Colors.red,
        primarySwatch: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: 'login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/products': (context) => const ProductsScreen(),
        '/mainPage': (context) => const MainPageScreen(),
        '/imageScreen': (context) => ImageScreen(),
        '/nullPage': (context) => NullPageScreen(),
        '/forHttp': (context) => forHttp(),
        '/checkImageScreen': (context) {
          File file = ModalRoute.of(context)!.settings.arguments as File;
          return CheckImageScreen(file);
        },
      },
    );
  }
}
