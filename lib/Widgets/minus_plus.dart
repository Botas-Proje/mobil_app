import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class Minus_Plus_Widget extends StatefulWidget {
  Minus_Plus_Widget(this.value, {super.key});

  String? value;
  @override
  State<Minus_Plus_Widget> createState() => _Minus_Plus_WidgetState();
}

class _Minus_Plus_WidgetState extends State<Minus_Plus_Widget> {
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

  @override
  Widget build(BuildContext context) {
    final arguments =
        (ModalRoute.of(context)?.settings.arguments ?? '') as String;

    return Scaffold(
      /*
      body: StreamBuilder(
        stream: _products.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.hasData) {
            var snap = _products..where('productName', isEqualTo: arguments);
            _dialogBuilder(snap);
          }
        },
      ),   */

      body: StreamBuilder(
        stream: _products.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.hasData) {
            final products = streamSnapshot.data!.docs;
            final filteredProducts = products
                .where((snapshot) => snapshot['productName'] == widget.value)
                .toList();

            return ListView.builder(
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {
                final documentSnapshot = filteredProducts[index];

                documentSnapshot['productName'] == widget.value
                    ? _dialogBuilder(documentSnapshot)
                    : print("Bir şeyler yanlış gitti");

                /*
                documentSnapshot['productName'] == widget.value
                    ? Navigator.pushNamed(context, "/alertDialog",
                        arguments: widget.value)
                    : print("Bir şeyler yanlış gitti");  */
              },
            );
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  void _dialogBuilder(QueryDocumentSnapshot<Object?> documentSnapshot) {
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
                "Ürün Adı : ${documentSnapshot["productName"]}\nMevcut Adet : ${documentSnapshot["productCount"]}",
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 5,
              ),
              TextField(
                controller: _productCountController,
                decoration: InputDecoration(
                  hintText: "Ürün sayısı giriniz",
                ),
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
                if (mounted) {
                  Navigator.of(context).pop();
                  Navigator.pushNamed(context, "/checkImageScreen");
                }

                /*
                Future.delayed(Duration.zero, () {
                  Navigator.of(context).pop();
                });
                */
              },
            ),
          ],
        );
      },
    );
  }
}

  /*
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
                SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
                  Navigator.of(context).pop();
                });

                /*
                Future.delayed(Duration.zero, () {
                  Navigator.of(context).pop();
                });
                */
              },
            ),
          ],
        );
      },
    );  
  }  */

