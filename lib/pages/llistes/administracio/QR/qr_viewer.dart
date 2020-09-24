import 'dart:ui';

import 'package:share/share.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:totfet/models/Finestra.dart';

class QRViewer extends StatefulWidget {
  final String id;
  final Finestra finestra;
  const QRViewer({Key key, this.id, @required this.finestra}) : super(key: key);

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
              colors: widget.finestra == Finestra.Tasques
                  ? <Color>[
                      Colors.orange[400],
                      Colors.deepOrange[900],
                    ]
                  : <Color>[
                      Colors.blue[400],
                      Colors.blue[900],
                    ],
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () async {
              // TODO: AIXO NO SE PERQUÈ NO FUNCIONA!!
              // Diu que la funció no està implementada, però em surt tot
              // com si sí que es pogués. WTF
              Share.share('check out my website https://example.com');
            },
          ),
        ],
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
              children: [
                Expanded(
                  child: Container(),
                  flex: 1,
                ),
                Text(
                  widget.id,
                  style: TextStyle(fontSize: 20),
                ),
                IconButton(
                  icon: Icon(hasCopied ? Icons.done : Icons.copy),
                  onPressed: () {
                    // Copia la ID al porta-retalls
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
                ),
                Expanded(
                  child: Container(),
                  flex: 1,
                ),
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
