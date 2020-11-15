import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_chat/Service/firebase.dart';
import 'package:video_chat/Views/SignUpPage.dart';

class SignPage extends StatefulWidget {
  @override
  _SignPageState createState() => _SignPageState();
}

class _SignPageState extends State<SignPage> {
  final _formKey = GlobalKey<FormState>();
  var isloading = false;
  Map<String, String> _authmap = {
    'email': "",
    'password': "",
    'name': "",
  };

  @override
  Widget build(BuildContext context) {
    final firebaseProvider =
        Provider.of<FirebaseServices>(context, listen: false);

    void onSaved() async {
      if (!_formKey.currentState.validate()) {
        return;
      }
      _formKey.currentState.save();
      setState(() {
        isloading = true;
      });
      await firebaseProvider.signInUser(
          _authmap["email"], _authmap["password"], context);

      setState(() {
        isloading = false;
      });
    }

    Widget textformfield(String text, bool obs) {
      return TextFormField(
        onSaved: (newValue) {
          if (text == "Username") {
            _authmap["name"] = newValue.trim();
          } else if (text == "Email") {
            _authmap["email"] = newValue.trim();
          } else if (text == "Password") {
            _authmap["password"] = newValue.trim();
          }
        },
        validator: (value) {
          if (value.isEmpty && text == "Email") {
            return ("Please enter your email");
          } else if (text == "Email" &&
              (!value.contains("@") || !value.contains(".com"))) {
            return ("Please enter a valid email ");
          }
          if (value.isEmpty && text == "Password") {
            return ("Please enter your password");
          }
          if (value.isEmpty && text == "Username") {
            return ("Please enter your username");
          }
        },
        obscureText: obs,
        style: TextStyle(color: Colors.white),
        cursorColor: Colors.white,
        decoration: InputDecoration(
          hintText: text,
          hintStyle: TextStyle(color: Colors.white),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: Colors.white, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: BorderSide(
              color: Colors.white,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: BorderSide(
              color: Colors.white,
            ),
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Form(
            key: _formKey,
            child: Center(
              child: SingleChildScrollView(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 40,
                        ),
                        child: Text(
                          "Video Chat APP ",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              fontStyle: FontStyle.italic,
                              color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Image(
                        image: AssetImage("lib/assets/images/appicon.png"),
                      ),
                      SizedBox(height: 25),
                      Text("Sign in now ",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic,
                              fontSize: 20)),
                      Divider(),
                      textformfield(
                        "Email",
                        false,
                      ),
                      Divider(),
                      textformfield(
                        "Password",
                        true,
                      ),
                      Divider(),
                      GestureDetector(
                        onTap: () => onSaved(),
                        child: isloading
                            ? Center(
                                child: CircularProgressIndicator(
                                  backgroundColor: Colors.red,
                                ),
                              )
                            : signButton(
                                text: "LOGIN",
                              ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Dont have an account ?",
                              style: TextStyle(color: Colors.white),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            InkWell(
                              onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SignUpPage(),
                                  )),
                              child: Text(
                                "Sign up now !",
                                style: TextStyle(color: Colors.red[700]),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class signButton extends StatelessWidget {
  final String text;
  const signButton({this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20), color: Colors.red[700]),
      padding: EdgeInsets.all(15),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
              color: Colors.white,
              fontStyle: FontStyle.italic,
              letterSpacing: 1),
        ),
      ),
    );
  }
}
