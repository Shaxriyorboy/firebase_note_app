import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_note/pages/sign_in_page.dart';
import 'package:firebase_note/pages/sign_up_page.dart';
import 'package:firebase_note/services/hive_service.dart';
import 'package:flutter/cupertino.dart';

class AuthService{
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  
  static Future<User?> signUpUser(String name,String email,String password)async{
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;
      print(user.toString());
      return user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  static Future<User?> signInUser(String email,String password)async{
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;
      print(user.toString());
      return user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }catch (e) {
      print(e);
    }
    return null;
  }

  static Future<void> delete(BuildContext context)async{
    try {
      await _auth.currentUser!.delete();
      Navigator.of(context).pushReplacementNamed(SignUpPage.id);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        print('The user must reauthenticate before this operation can be executed.');
      }
    }
  }

  static void signOutUser(BuildContext context)async{
    await _auth.signOut();
    HiveDB.removeIdUser().then((value) {
      Navigator.of(context).pushReplacementNamed(SignInPage.id);
    });
  }
}