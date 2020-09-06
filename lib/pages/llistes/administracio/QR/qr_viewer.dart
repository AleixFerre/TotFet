import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
        title: Center(
          child: Text("Codi QR"),
        ),
      ),
      body: Builder(
        builder: (context) => Column(
          children: [
            // TODO: Fer el visualitzador de QR per la ID entrada
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
          ],
        ),
      ),
    );
  }
}
