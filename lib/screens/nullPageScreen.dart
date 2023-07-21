import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NullPageScreen extends StatelessWidget {
  const NullPageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Bulunamadı",
        ),
      ),
      body: Center(
          child: Container(
        child: Text("Aradığınız resim bulunamadı"),
      )),
    );
  }
}
