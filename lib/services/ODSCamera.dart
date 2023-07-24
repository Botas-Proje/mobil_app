import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class ODSCamera extends StatefulWidget {
  @override
  _ODSCameraState createState() => _ODSCameraState();
}

class _ODSCameraState extends State<ODSCamera> {
  File? imageFile;
  File? compressedFile;
  final _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
  }

  Future<void> compress() async {
    var result = await FlutterImageCompress.compressAndGetFile(
      imageFile!.absolute.path,
      imageFile!.path + 'compresses.jpg',
      quality: 88,
    );

    setState(() {
      compressedFile = result as File?;
    });
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

  Future<void> fetchData() async {
    final response = await http.get(Uri.parse('http://10.10.208.123:8080/web'));
    if (response.statusCode == 200) {
      print('Başarılı cevap: ${response.body}');
    } else {
      print('İstek başarısız: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Tasarım kodları
    if (imageFile == null) {
      _pickImageBase64Camera();
      compress();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Ürünler'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                fetchData();
              },
              child: Text('Web Servisi isteği'),
            ),
            imageFile == null
                ? Container(
                    child: Text("Henüz resim yüklemediniz."),
                    padding: EdgeInsets.symmetric(vertical: 50),
                  )
                : Image.file(imageFile!),
            if (compressedFile != null)
              Image.file(
                compressedFile!,
                height: 200,
              ),
            if (compressedFile != null)
              Text(
                '${compressedFile!.lengthSync()} bytes',
              )
          ],
        ),
      ),
    );
  }
}
