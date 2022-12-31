// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import '../models/response_model copy.dart';
export 'package:firebase_auth/firebase_auth.dart' show User;

class FirebaseUserModule {
  static FirebaseAuth auth = FirebaseAuth.instance;

  static Stream<User?> userLoginState() {
    return auth.userChanges();
  }


  static Future<ResponseModel> createUser(String email, String password) async {
    try {
      FirebaseApp app = await Firebase.initializeApp(
          name: 'Secondary', options: Firebase.app().options);
      FirebaseAuth _auth = FirebaseAuth.instanceFor(app: app);

      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      await app.delete();

      return ResponseModel(
          ResponseType.success, userCredential.user?.uid); // return user id;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return ResponseModel(ResponseType.warning, 'weak-password');
      } else if (e.code == 'email-already-in-use') {
        return ResponseModel(ResponseType.warning, 'email-already-in-use');
      }
      return ResponseModel(ResponseType.error, e);
    } catch (e) {
      return ResponseModel(ResponseType.error, e);
    }
  }

  static Future<ResponseModel> login(String email, String password) async {
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      return ResponseModel(
          ResponseType.success, userCredential.user?.uid.toString());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return ResponseModel(ResponseType.warning, 'user-not-found');
      } else if (e.code == 'wrong-password') {
        return ResponseModel(ResponseType.warning, 'wrong-password');
      }
      return ResponseModel(ResponseType.error, e);
    } catch (e) {
      return ResponseModel(ResponseType.error, e);
    }
  }

  static Future<void> logout() async {
    await Future.delayed(const Duration(seconds: 2));

    await auth.signOut();
  }
}
