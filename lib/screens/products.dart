import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ürünler"),
        actions: [
          ElevatedButton(
            onPressed: () {
              if (mounted) {
                // Navigator.pushNamed(context, "/forHttp");
                Navigator.pushNamed(context, "/checkImageScreen");
              }
            },
            child: const Row(
              children: [
                Text("Web servis"),
                Icon(Icons.forward),
              ],
            ),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: _products.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.hasData) {
            return ListView.builder(
              itemCount: streamSnapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final DocumentSnapshot documentSnapshot =
                    streamSnapshot.data!.docs[index];
                return Card(
                  margin: const EdgeInsets.all(15),
                  child: ListTile(
                    title: Text(documentSnapshot['productName']),
                    subtitle: Text(documentSnapshot['productCount'].toString()),
                    trailing: SizedBox(
                      width: 100,
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () => _dialogBuilder(documentSnapshot),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
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
