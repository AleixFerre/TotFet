import 'package:firebase_auth/firebase_auth.dart';
import 'package:llista_de_la_compra/models/Usuari.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Creates a User instance based on the Firebase user
  Usuari _userFromFirebaseUser(User user) {
    return user != null ? Usuari(uid: user.uid) : null;
  }

  // auth change user stream
  Stream<Usuari> get user {
    return _auth.authStateChanges().map(_userFromFirebaseUser);
  }

  // sign in anon
  Future signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // sign in email psw
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      User user = result.user;
      return {
        "response": _userFromFirebaseUser(user),
        "error": null,
      };
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return {
          "response": null,
          "error": "No existeix cap usuari amb aquesta adreça electrònica.\n" +
              e.toString()
        };
      } else if (e.code == 'wrong-password') {
        return {
          "response": null,
          "error": "La contrasenya és incorrecta, torna a intentar-ho.\n" +
              e.toString()
        };
      } else {
        return {
          "response": null,
          "error": "Hi ha hagut un error desconegut, torna a intentar-ho.\n" +
              e.toString()
        };
      }
    } catch (e) {
      print(e.toString());
      return {
        "response": null,
        "error": e.toString(),
      };
    }
  }

  // register email psw
  Future registerWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      User user = result.user;
      return {
        "response": _userFromFirebaseUser(user),
        "error": null,
      };
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('Contrasenya massa dèbil.');
        return {
          "response": null,
          "error": "Contrasenya massa dèbil. Prova amb una de més complicada.",
        };
      } else if (e.code == 'email-already-in-use') {
        print('Ja existeix una conta amb aquest correu electrònic');
        return {
          "response": null,
          "error": "Ja existeix una conta amb aquesta adreça.",
        };
      } else if (e.code == 'invalid-email') {
        print('Adreça de correu no vàlida');
        return {
          "response": null,
          "error": "Siusplau introdueix una adreça de correu vàlida.",
        };
      } else {
        return {
          "response": null,
          "error": "Hi ha hagut un error desconegut, torna a intentar-ho.\n" +
              e.toString()
        };
      }
    } catch (e) {
      print(e.toString());
      return {
        "response": null,
        "error": e.toString(),
      };
    }
  }

  // sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
