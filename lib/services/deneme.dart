import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'package:image_picker/image_picker.dart';

class ImageProcessingPage extends StatefulWidget {
  @override
  _ImageProcessingPageState createState() => _ImageProcessingPageState();
}

class _ImageProcessingPageState extends State<ImageProcessingPage> {
  File? _selectedImage;
  String _base64String = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Processing'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _selectedImage != null
                ? Image.file(
                    _selectedImage!,
                    height: 200,
                    width: 200,
                  )
                : Container(),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _selectImageFromGallery();
              },
              child: Text('Select Image'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (_selectedImage != null) {
                  String base64String = await processImage(_selectedImage!);
                  setState(() {
                    _base64String = base64String;
                  });
                } else {
                  print('Please select an image first.');
                }
              },
              child: Text('Process Image'),
            ),
            SizedBox(height: 20),
            Text("byte : ${imageBytes.length}"),
            Text('Base64 String: ${_base64String.length}'),
          ],
        ),
      ),
    );
  }

  Future<void> _selectImageFromGallery() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _selectedImage = File(pickedImage.path);
      });
    }
  }

  late List<int> imageBytes = [0];
  Future<String> processImage(File imageFile) async {
    final tempDir = await getTemporaryDirectory();
    final targetPath = tempDir.path + '/compressed_image.jpg';

    final result = await FlutterImageCompress.compressAndGetFile(
      imageFile.absolute.path,
      targetPath,
      quality: 80,
      minWidth: 416,
      minHeight: 416,
    );

    if (result != null) {
      // List<int> imageBytes = await result.readAsBytes();
      imageBytes = await result.readAsBytes();
      String base64String = base64Encode(imageBytes);
      return base64String;
    } else {
      print('Compression failed.');
      return '';
    }
  }
}
