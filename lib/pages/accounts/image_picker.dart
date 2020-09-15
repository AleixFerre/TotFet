import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageCapture extends StatefulWidget {
  ImageCapture({this.img});
  final File img;

  @override
  _ImageCaptureState createState() => _ImageCaptureState();
}

class _ImageCaptureState extends State<ImageCapture> {
  final ImagePicker imagePicker = new ImagePicker();
  File _imageFile;

  @override
  void initState() {
    super.initState();
    _imageFile = widget.img;
  }

  Future<void> _pickImage(ImageSource source) async {
    PickedFile selected = await imagePicker.getImage(source: source);

    setState(() {
      _imageFile = selected as File;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Editar foto de perfil"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.add_photo_alternate),
            onPressed: () async {
              await _pickImage(ImageSource.gallery);
            },
          ),
          IconButton(
            icon: Icon(Icons.add_a_photo),
            onPressed: () async {
              await _pickImage(ImageSource.camera);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Image.file(_imageFile),
          SizedBox(
            height: 30,
          ),
          RaisedButton(
            padding: EdgeInsets.all(8),
            onPressed: () {
              // TODO: PUJAR AL NUVOL
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Pujar al núvol",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.w300),
                ),
                SizedBox(
                  width: 10,
                ),
                Icon(
                  Icons.cloud_upload,
                  size: 30,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
