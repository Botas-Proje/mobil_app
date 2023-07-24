//ANALİZ İÇİN

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CheckImageScreen extends StatefulWidget {
  const CheckImageScreen({super.key});

  @override
  State<CheckImageScreen> createState() => _CheckImageScreenState();
}

class _CheckImageScreenState extends State<CheckImageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    if (mounted) {
                      Navigator.pushNamed(context, "/ODSCamera");
                    }
                  },
                  child: const Text("Kameradan resim çek"),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (mounted) {
                      Navigator.pushNamed(context, "/ODSGallery");
                    }
                  },
                  child: const Text("Galeriden resim seç"),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (mounted) {
                      Navigator.pushNamed(context, "/deneme");
                    }
                  },
                  child: const Text("Deneme için"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
