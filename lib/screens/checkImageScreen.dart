//ANALİZ İÇİN

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CheckImageScreen extends StatefulWidget {
  const CheckImageScreen(this.file, {super.key});

  final File file;

  @override
  State<CheckImageScreen> createState() => _CheckImageScreenState();
}

class _CheckImageScreenState extends State<CheckImageScreen> {
  @override
  Widget build(BuildContext context) {
    print(widget.file.toString());
    // final arguments = ModalRoute.of(context)?.settings.arguments as File?;

    if (widget.file == null) {
      return const Center(
        child: CircularProgressIndicator.adaptive(),
      );
    }

    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Column(
              children: [
                Image.file(widget.file),
                TextButton(
                  onPressed: null,
                  child: Text("Sonuçlar"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
