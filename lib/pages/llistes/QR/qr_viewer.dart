import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class QRViewer extends StatelessWidget {
  final String id;
  const QRViewer({Key key, this.id}) : super(key: key);

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
                  id,
                  style: TextStyle(fontSize: 30),
                ),
                IconButton(
                  icon: Icon(Icons.copy),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: id));
                    Scaffold.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Codi copiat correctament!"),
                      ),
                    );
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
