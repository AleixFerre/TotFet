import 'package:flutter/material.dart';
import 'package:compres/services/auth.dart';

class SortirSessio extends StatelessWidget {
  final AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.exit_to_app),
      tooltip: "Sortir de la sessió",
      onPressed: () async {
        // Show alert box
        bool sortir = await showDialog<bool>(
          context: context,
          barrierDismissible: true,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Vols sortir de la sessió?'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Text(
                      'Pots tornar a iniciar sessió quan vulguis!',
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text(
                    'Cancel·lar',
                    style: TextStyle(fontSize: 20),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                ),
                FlatButton(
                  child: Text(
                    'Sortir',
                    style: TextStyle(fontSize: 20),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                ),
              ],
            );
          },
        );

        // Si esborrar és null o false, llavors no es fa res
        if (sortir == true) {
          await _auth.signOut();
        }
      },
    );
  }
}
