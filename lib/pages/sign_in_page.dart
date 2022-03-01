import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_note/pages/home_page.dart';
import 'package:firebase_note/pages/sign_up_page.dart';
import 'package:firebase_note/services/hive_service.dart';
import 'package:flutter/material.dart';

import '../services/auth_service.dart';
class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);
  static const String id = "sign_in_page";

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  bool isLoading = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String error = "";
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void showInSnackBar(String value) {
    _scaffoldKey.currentState?.showSnackBar(new SnackBar(
        content: new Text(value)
    ));
  }

  void  _doSingUp() async{
    String email = emailController.text.trim().toString();
    String password = passwordController.text.trim().toString();

    setState(() {
      isLoading = true;
    });

    if(email.isEmpty || password.isEmpty) {
      setState(() {
        isLoading = false;
        error = "Please enter email or password";
      });
      return;
    }

    await AuthService.signInUser(email, password).then((value) => {
      _getFirebaseUser(value),
    });
  }

  void _getFirebaseUser(User? user)async{
    setState(() {
      isLoading = false;
    });
    if(user != null){
      await HiveDB.storeIdUser(user.uid);
      Navigator.of(context).pushReplacementNamed(HomePage.id);
    }else{
      /// print error msg
      setState(() {
        error = "Not Found this user";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: emailController,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  hintText: "Email",
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(
                  hintText: "Password",
                ),
              ),
              SizedBox(
                height: 20,
              ),
              MaterialButton(
                height: 50,
                minWidth: MediaQuery.of(context).size.width,
                color: Colors.blueAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                onPressed: () {
                  showInSnackBar(error);
                  _doSingUp();
                },
                child: Text("Sign In"),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "Don't have an account ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  InkWell(
                      onTap: (){
                        Navigator.pushReplacementNamed(context, SignUpPage.id);
                      },
                      child: Text(
                        "Sign Up",
                        style: TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.bold),
                      )),
                ],
              )
            ],
          ),
        ),
      )
    );
  }
}
