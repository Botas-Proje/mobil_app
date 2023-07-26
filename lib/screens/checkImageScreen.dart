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
      appBar: AppBar(actions: [
        IconButton(
            onPressed: () {
              if (mounted) {
                Navigator.pushNamed(context, "/products");
              }
            },
            icon: const Icon(Icons.folder))
      ]),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Resmi nereden yükleyeceğinizi seçiniz.",
                  style: TextStyle(fontSize: 17),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (mounted) {
                      Navigator.pushNamed(context, "/gallery");
                    }
                  },
                  child: const Text("Galeriden  seç"),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (mounted) {
                      Navigator.pushNamed(context, "/camera");
                    }
                  },
                  child: const Text("Kameradan al"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
