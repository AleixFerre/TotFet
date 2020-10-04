import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:totfet/models/Usuari.dart';
import 'package:totfet/services/storage.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class ImageCapture extends StatefulWidget {
  ImageCapture({this.imgPath, this.nom});
  final String imgPath;
  final String nom;

  @override
  _ImageCaptureState createState() => _ImageCaptureState();
}

class _ImageCaptureState extends State<ImageCapture> {
  final ImagePicker imagePicker = new ImagePicker();
  File _imageFile;
  bool firstTime = true;
  bool mostrarInicials = false;
  StorageUploadTask _uploadTask;
  double progress = 0.0;
  bool editat = false;

  @override
  void initState() {
    super.initState();
    if (widget.imgPath == null) {
      mostrarInicials = true;
    } else {
      _imageFile = File(widget.imgPath);
    }
  }

  Future<File> _compressImage(File cropped, String path) async {
    File result = await FlutterImageCompress.compressAndGetFile(
      cropped.path,
      path,
      quality: 50,
    );
    return result;
  }

  Future<void> _cropImage(String path) async {
    File cropped = await ImageCropper.cropImage(
      sourcePath: path,
      aspectRatio: CropAspectRatio(
        ratioX: 1,
        ratioY: 1,
      ),
      androidUiSettings: AndroidUiSettings(
        toolbarColor: Colors.blue,
        toolbarWidgetColor: Colors.white,
        toolbarTitle: "Retalla la imatge",
      ),
    );

    if (cropped == null) return;

    File compressed = await _compressImage(cropped, path);

    setState(() {
      _imageFile = compressed;
      _uploadTask = null;
      firstTime = false;
      editat = true;
    });
  }

  Future<void> _pickImage(ImageSource source) async {
    PickedFile selected = await imagePicker.getImage(source: source);

    if (selected == null) return;

    // Crop image to 1:1 size
    await _cropImage(selected.path);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => editat
          ? showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text("Tens canvis sense guardar!"),
                content: Text("Vols sortir sense guardar?"),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("Cancel·lar"),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    },
                    child: Text("Sortir"),
                  ),
                ],
              ),
            )
          : true,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Editar foto de perfil" + (editat ? "*" : "")),
          centerTitle: true,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: <Color>[
                  Colors.blue[400],
                  Colors.blue[900],
                ],
              ),
            ),
          ),
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
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (firstTime)
                if (mostrarInicials)
                  Hero(
                    tag: "ImgPerfil",
                    child: CircleAvatar(
                      backgroundColor: Colors.blue,
                      radius: 100,
                      child: Text(
                        Usuari.inicials(widget.nom),
                        style: TextStyle(fontSize: 100),
                      ),
                    ),
                  )
                else
                  Hero(
                    tag: "ImgPerfil",
                    child: Image.network(
                      _imageFile.path,
                      height: 200,
                    ),
                  )
              else
                Hero(
                  tag: "ImgPerfil",
                  child: Image.file(
                    _imageFile,
                    height: 200,
                  ),
                ),
              SizedBox(
                height: 30,
              ),
              if (_uploadTask != null)
                StreamBuilder<StorageTaskEvent>(
                  stream: _uploadTask.events,
                  builder: (_, snapshot) {
                    StorageTaskSnapshot event = snapshot?.data?.snapshot;

                    double progressPercent = event != null
                        ? event.bytesTransferred / event.totalByteCount
                        : 0;

                    return Column(
                      children: [
                        if (_uploadTask.isComplete)
                          Column(children: [
                            Text(
                              '🎉🎉🎉',
                              style: TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "Wow la imatge s'ha pujat perfectament!\nJa pots tancar la finestra.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ]),

                        if (_uploadTask.isPaused)
                          FlatButton(
                            child: Icon(Icons.play_arrow),
                            onPressed: _uploadTask.resume,
                          ),

                        if (_uploadTask.isInProgress)
                          FlatButton(
                            child: Icon(Icons.pause),
                            onPressed: _uploadTask.pause,
                          ),

                        SizedBox(
                          height: 20,
                        ),

                        // Progress bar
                        LinearProgressIndicator(value: progressPercent),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          '${(progressPercent * 100).toStringAsFixed(2)} % ',
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    );
                  },
                )
              else
                RaisedButton(
                  elevation: 3,
                  padding: EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                  onPressed: firstTime
                      ? null
                      : () async {
                          // PUJAR AL NUVOL
                          if (firstTime) return;
                          setState(() {
                            _uploadTask =
                                StorageService().uploadImage(_imageFile);
                            editat = false;
                          });
                        },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Pujar al núvol",
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.w300),
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
                ),
            ],
          ),
        ),
      ),
    );
  }
}
