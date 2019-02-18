import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'authpage.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class LoginPage extends StatefulWidget {
  @override
  createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> {
  TextEditingController email = TextEditingController();
  TextEditingController passkey = TextEditingController();

  Future<FirebaseUser> _signIn(String email, String password) async {
    final FirebaseUser user = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
//    final FirebaseUser currentUser = await _auth.currentUser();
//    assert(user == currentUser);

    return user;
  }

  @override
  Widget build(BuildContext context) {
    final id = TextFormField(
      controller: email,
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      decoration: InputDecoration(
        labelText: 'Email',
        hintText: 'Enter your email',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(),
      ),
    );

    final password = TextFormField(
      controller: passkey,
      autofocus: false,
      obscureText: true,
      cursorColor: Colors.white,
      decoration: InputDecoration(
        fillColor: Colors.white,
        labelText: 'Password',
        hintText: 'Enter your password',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(),
      ),
    );

    final loginButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: MaterialButton(
        elevation: 10.0,
        minWidth: 200.0,
        height: 42.0,
        onPressed: () async {
          FirebaseUser user = await _signIn(email.text, passkey.text);
          final message = user.email;
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => AuthPage(
                message: message,
              ),
            ),
          );
          print(message);
        },
        color: Color(int.parse("ff004b99", radix: 16)),
        child: Text('Log In', style: TextStyle(color: Colors.white)),
      ),
    );

    final forgotPassword = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: FlatButton(
        color: Colors.black,
        onPressed: () {
          // Navigator.of(context).pushNamed('/SelectionPage');
        },
        child: Text('Forgot Password?', style: TextStyle(color: Colors.blue)),
      ),
    );

    final panel = Center(
      child: Card(
        color: Colors.white,
        elevation: 6.0,
        margin: EdgeInsets.only(left: 20.0, right: 20.0),
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(left: 24.0, right: 24.0),
          children: <Widget>[
            SizedBox(height: 16.0),
            Text("2-Factor Authentication",
                textAlign: TextAlign.center, style: TextStyle(fontSize: 20.0)),
            SizedBox(height: 18.0),
            id,
            SizedBox(height: 10.0),
            password,
            SizedBox(height: 14.0),
            loginButton,
            forgotPassword,
          ],
        ),
      ),
    );

    return Container(
      decoration: BoxDecoration(color: Colors.black),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 18.0,
            ),
            panel,
          ],
        ),
      ),
    );
  }
}
