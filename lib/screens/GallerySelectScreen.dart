import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:mpaiapp/Widgets/MyCard.dart';
import 'package:mpaiapp/services/HttpService.dart';
import 'package:path_provider/path_provider.dart';

class GallerySelectScreen extends StatefulWidget {
  @override
  _GallerySelectScreenState createState() => _GallerySelectScreenState();
}

class _GallerySelectScreenState extends State<GallerySelectScreen> {
  File? imageFile;
  File? compressedFile;
  String? endValue;

  final _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
  }

  String values = '';
  List<String> results = [];
  Map<String, dynamic> end = {};
  Map<String, dynamic> short_end = {};
  // var Priz = "";
  // var Telefon = "";
  // var Klavye = "";
  XFile? image;
  //base64
  void _pickImageBase64Gallery() async {
    // const maxSize = 146 * 146;
    final image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 25,
        maxHeight: 600,
        maxWidth: 900);

    print(image!.length());

    final String directory = (await getApplicationDocumentsDirectory()).path;
    final String imagePath = '$directory/resim.jpg';
    print(imagePath);
    if (image != null) {
      await image.saveTo(imagePath);
    }

    if (image == null) {
      print("resim değeri null");
      return;
    }
    if (image != null) {
      setState(() {
        imageFile = File(image.path);
      });
    }

    if (image != null) {
      List<int> imageBytes = await image.readAsBytes();
      String base64String = base64Encode(imageBytes);

      //son hali nasıl
      print(base64String.length);
      print(base64String);

      //json formatında post etme
      print("JSONN");
      var json = jsonEncode({'image': base64String});
      print(json);

      final response = await HttpService.post('', {'image': base64String});
      values = response.body;
      results = values.split(",");
      for (var i = 0; i < results.length; i++) {
        var deger = results[i].split(":");
        var key = deger[0];
        var value = deger[1];
        end[key] = value;
      }

      print("---------------------------");
      setState(() {
        values;
      });
      print(values);
      print("val : ${values}");

      if (response.statusCode == 200) {
        print('Başarılı cevap: ${response.body}');
      } else {
        print('İstek başarısız: ${response.statusCode}');
      }
    } else {
      print("Failed...");
    }
  }

  @override
  Widget build(BuildContext context) {
    //çıkan en büyük sonucu dönecek

    Map<String, dynamic> shorting(Map<String, dynamic> map) {
      for (var i in map.keys) {
        var value = double.parse(map[i]);
        short_end[i] = value;
      }
      var sortedByValueMap = Map.fromEntries(short_end.entries.toList()
        ..sort((e1, e2) =>
            e1.value.compareTo(e2.value))); //büyükten küçüğe sıralar
      var index = sortedByValueMap.keys.first;
      var result = {index: sortedByValueMap[index]};

      return result;
    }

    // Tasarım kodları
    if (imageFile == null) {
      _pickImageBase64Gallery();
    }

    setState(() {
      values;
      end;
      //  Telefon;
      //  Priz;
      //  Klavye;
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('Ürünler'),
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
                : Column(
                    children: [
                      values == null
                          ? CircularProgressIndicator()
                          : Column(
                              children: [
                                SizedBox(
                                  width: MediaQuery.sizeOf(context).width * 0.3,
                                  child: Image.file(imageFile!),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: SizedBox(
                                    child: Text(
                                      "Görüntüyü hangi nesne sınıfına kaydetmek istediğinizi seçiniz.",
                                      style: TextStyle(
                                          fontSize: 17, fontFamily: "Poppins"),
                                    ),
                                  ),
                                ),
                                for (var i in end.keys)
                                  MyCard(i, i + ":" + end[i]),

                                /*
                                for (var i in shorting(exampleMap).keys)
                                  MyCard(
                                      i,
                                      i +
                                          ":" +
                                          shorting(exampleMap)[i].toString()),    */
                              ],
                            ),
                      // Image.file(imageFile!),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
