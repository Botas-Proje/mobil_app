import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_toolbar/flutter_toolbar.dart';
import 'package:image_picker/image_picker.dart';

class ImageScreen extends StatefulWidget {
  const ImageScreen({super.key});

  @override
  State<ImageScreen> createState() => _ImageScreenState();
}

class _ImageScreenState extends State<ImageScreen> {
  File? imageFile;
  final _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
  }

  //base64
  void _pickImageBase64Camera() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image == null) {
      print("resim değeri null");
      return;
    }

    Uint8List imagebyte = await image!.readAsBytes();
    String _base64 = base64.encode(imagebyte);

    print(_base64);

    final imagetemppath = File(image.path);

    setState(() {
      this.imageFile = imagetemppath;
    });
  }

  //base64
  void _pickImageBase64Gallery() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image == null) {
      print("resim değeri null");
      return;
    }

    Uint8List imagebyte = await image!.readAsBytes();
    String _base64 = base64.encode(imagebyte);

    print(_base64);

    final imagetemppath = File(image.path);

    setState(() {
      this.imageFile = imagetemppath;
    });
  }

  Future<File?> _imgPath() async {
    return imageFile;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Resim seçin"),
        actions: [
          ElevatedButton(
            onPressed: () {
              if (mounted) {
                Navigator.pushNamed(context, "/products");
              }
            },
            child: const Row(
              children: [
                Text("Tüm ürünler"),
                Icon(Icons.forward),
              ],
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            imageFile == null
                ? Container(
                    child: Text("Henüz resim yüklemediniz."),
                    padding: EdgeInsets.symmetric(vertical: 50),
                  )
                : Image.file(imageFile!),
            // const CircularProgressIndicator(valueColor:AlwaysStoppedAnimation(Colors.red),),//Image.file(imageFile!),
            ElevatedButton(
              onPressed: () {
                imageFile == null;
                _pickImageBase64Camera();
              },
              child: const Text("Kameradan resim çek"),
            ),
            ElevatedButton(
              onPressed: () {
                imageFile == null;
                _pickImageBase64Gallery();
              },
              child: const Text("Galeriden resim seç"),
            ),
          ],
        ),
      ),
    );
  }
}
