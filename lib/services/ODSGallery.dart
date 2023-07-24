import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:mpaiapp/services/HttpService.dart';
import 'package:path_provider/path_provider.dart';

class ODSGallery extends StatefulWidget {
  @override
  _ODSGalleryState createState() => _ODSGalleryState();
}

class _ODSGalleryState extends State<ODSGallery> {
  File? imageFile;
  File? compressedFile;
  String? endValue;
  final _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
  }

  XFile? image;
  //base64
  void _pickImageBase64Gallery() async {
    // const maxSize = 146 * 146;
    final image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 25,
    ); //maxHeight: 600,
    //maxWidth: 900

    if (image == null) {
      print("resim değeri null");
      return;
    }
    if (image != null) {
      setState(() {
        imageFile = File(image.path);
      });
    }

    //resmin boyutunu ayarlama
    //var fileSize = imagebyte.length;
    //while (maxSize < fileSize) {}
    /*
    final tempDir = await getTemporaryDirectory();
    final targetPath = tempDir.path + '/compressed_image.jpg';

    final result = await FlutterImageCompress.compressAndGetFile(
      imageFile!.absolute.path,
      targetPath,
      quality: 60,
      minWidth: 416,
      minHeight: 416,
    ); */

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
      var k = response.body;
      print("---------------------------");
      print(k);
      if (response.statusCode == 200) {
        print('Başarılı cevap: ${response.body}');
      } else {
        print('İstek başarısız: ${response.statusCode}');
      }
    } else {
      print("Failed...");
    }
  }

  void getSuggestion(value) {
    String newVal = value[0].toUpperCase() +
        value.substring(1); // To make the first character always on uppercase.
    late final listOfSearchedData;

    FirebaseFirestore.instance
        .collection('products')
        .orderBy('document', descending: false)
        .startAt([newVal])
        .endAt([newVal + '\uf8ff'])
        .get()
        .then((QuerySnapshot snapshot) {
          setState(() {
            listOfSearchedData = snapshot.docs;
          });
          return listOfSearchedData;
        })
        .catchError((error) {
          print('Error: $error');
        });
  }

  Future<void> fetchData() async {
    /*
    final response = await http.get(Uri.parse('http://10.10.208.123:8080/web'));
    if (response.statusCode == 200) {
      print('Başarılı cevap: ${response.body}');
    } else {
      print('İstek başarısız: ${response.statusCode}');
    }   */
  }

  @override
  Widget build(BuildContext context) {
    // Tasarım kodları
    if (imageFile == null) {
      _pickImageBase64Gallery();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Ürünler'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            /*
            ElevatedButton(
              onPressed: () {
                fetchData();
              },
              child: Text('Web Servisi isteği'),
            ),
            */
            imageFile == null
                ? Container(
                    child: Text("Henüz resim yüklemediniz."),
                    padding: EdgeInsets.symmetric(vertical: 50),
                  )
                : Column(
                    children: [
                      // Image.file(imageFile!),
                      SizedBox(
                        width: MediaQuery.sizeOf(context).width * 0.4,
                        child: Image.file(imageFile!),
                      ),
                      Text(
                        "Görüntüyü hangi nesne sınıfına kaydetmek istediğinizi seçiniz.",
                      ),
                      TextButton(
                        onPressed: () {
                          setState(
                            () {
                              String value = "Telefon";
                              /*
                              Stream streamQuery = _products
                                  .where('productName',
                                      isGreaterThanOrEqualTo: value)
                                  .where('productCount',
                                      isLessThan: value + 'z')
                                  .snapshots();  */

                              //_dialogBuilder();
                            },
                          );
                        },
                        child: Text("Telefon : 0.60"),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text("Priz : 0.10"),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text("Telefon : 0.30"),
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }

  //ürün ekleme işlemlerini güncellemek için.

  final CollectionReference _products =
      FirebaseFirestore.instance.collection('products');

  final _productNameController = TextEditingController();
  final _productCountController = TextEditingController();

  Future<void> _update([DocumentSnapshot? documentSnapshot]) async {
    if (documentSnapshot != null) {
      _productNameController.text = documentSnapshot['productName'];
      _productCountController.text =
          documentSnapshot['productCount'].toString();
    }
  }

  void _dialogBuilder(DocumentSnapshot documentSnapshot) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Ürünü Güncelleyin'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                height: 5,
              ),
              Text(
                "Ürün Adı : ${documentSnapshot["productName"]}",
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 5,
              ),
              CupertinoTextField(
                controller: _productCountController,
                placeholder: "Ürün sayısı giriniz",
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('Ekle'),
              onPressed: () async {
                final String productName = _productNameController.text;
                final int? productCount =
                    int.tryParse(_productCountController.text);
                _update(documentSnapshot);
                if (productCount != null) {
                  int num = int.parse(_productCountController.text);
                  await _products.doc(documentSnapshot!.id).update({
                    // "productName": productName,
                    "productCount": productCount + num
                  });
                  _productNameController.text = "";
                  _productCountController.text = "";
                }
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Çıkart'),
              onPressed: () async {
                final String productName = _productNameController.text;
                final int? productCount =
                    int.tryParse(_productCountController.text);
                _update(documentSnapshot);
                if (productCount != null) {
                  int num = int.parse(_productCountController.text);
                  await _products.doc(documentSnapshot!.id).update({
                    // "productName": productName,
                    "productCount": productCount - num
                  });
                  _productNameController.text = "";
                  _productCountController.text = "";
                }
                Navigator.of(context).pop();
              },
            ),
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
