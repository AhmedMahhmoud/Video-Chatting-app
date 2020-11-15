import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_chat/Service/firebase.dart';

import 'package:video_chat/Views/SignPage.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  Map<String, String> _authmap = {
    'email': "",
    'password': "",
    'name': "",
  };
  final _formKey = GlobalKey<FormState>();
  var isloading = false;
  @override
  Widget build(BuildContext context) {
    final firebaseProvider =
        Provider.of<FirebaseServices>(context, listen: false);

    void _onSaved() async {
      if (!_formKey.currentState.validate()) {
        return;
      }
      _formKey.currentState.save();
      setState(() {
        isloading = true;
      });
      await firebaseProvider
          .signUpUser(_authmap["name"], _authmap["email"], _authmap["password"],
              context)
          .then((value) => Navigator.pop(context))
          .catchError((e) {
        print(e);
      });
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
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Center(
                child: Container(
                  padding: EdgeInsets.only(top: 100),
                  child: Column(
                    children: [
                      Text(
                        "Lets sign you up !",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontStyle: FontStyle.italic),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      textformfield(
                        "Username",
                        false,
                      ),
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
                      InkWell(
                        onTap: () => _onSaved(),
                        child: isloading
                            ? Center(
                                child: CircularProgressIndicator(
                                backgroundColor: Colors.red,
                              ))
                            : signButton(
                                text: "SUBMIT",
                              ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
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
