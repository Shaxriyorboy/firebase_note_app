import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_note/pages/detail_page.dart';
import 'package:firebase_note/pages/home_page.dart';
import 'package:firebase_note/pages/sign_in_page.dart';
import 'package:firebase_note/pages/sign_up_page.dart';
import 'package:firebase_note/services/hive_service.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox(HiveDB.dbName);
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  Widget _getLandingPage() {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasData) {
          HiveDB.storeIdUser(snapshot.data!.uid);
          return HomePage();
        } else {
          HiveDB.removeIdUser();
          return SignInPage();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase Note App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: _getLandingPage(),
      routes: {
        HomePage.id:(context) => HomePage(),
        SignInPage.id:(context) => SignInPage(),
        SignUpPage.id:(context) => SignUpPage(),
        DetailPage.id:(context) => DetailPage(),
      },
    );
  }
}

