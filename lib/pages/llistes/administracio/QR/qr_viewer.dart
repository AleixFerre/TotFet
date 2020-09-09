import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRViewer extends StatefulWidget {
  final String id;
  const QRViewer({Key key, this.id}) : super(key: key);

  @override
  _QRViewerState createState() => _QRViewerState();
}

class _QRViewerState extends State<QRViewer> {
  bool hasCopied = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Codi QR"),
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
      ),
      body: Builder(
        builder: (context) => Column(
          children: [
            // Visualitzador de QR per la ID entrada
            Expanded(
              flex: 3,
              child: Center(
                child: QrImage(
                  data: widget.id,
                  size: 300,
                ),
              ),
            ),
            Text("o copia el codi"),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  widget.id,
                  style: TextStyle(fontSize: 20),
                ),
                IconButton(
                  icon: Icon(hasCopied ? Icons.done : Icons.copy),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: widget.id));
                    Scaffold.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Codi copiat correctament!"),
                      ),
                    );
                    setState(() {
                      hasCopied = true;
                    });
                  },
                )
              ],
            ),
            Expanded(
              child: Container(),
              flex: 1,
            ),
          ],
        ),
      ),
    );
  }
}
