import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthPage extends StatefulWidget {
  final message;

  AuthPage({this.message});

  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  CollectionReference authStateCollection =
      Firestore.instance.collection('auth');

  void changeAuthState(newState) {
    Firestore.instance.runTransaction((transaction) async {
      await transaction.update(
          authStateCollection.document(this.widget.message),
          {'state': newState.toString()});
    });
  }

  void authenticate() async {
    var localAuth = LocalAuthentication();
    bool didAuthenticate = await localAuth.authenticateWithBiometrics(
        localizedReason: 'Authenticate to Login to the Website',
        stickyAuth: true
    );

    if (didAuthenticate) {
      changeAuthState('2');
    } else {
      changeAuthState('-1');
    }
  }

  Widget buildAuthCard() {
    return Card(
      color: Colors.black,
      child: Center(
        child: StreamBuilder(
          stream: authStateCollection.document(this.widget.message).snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return CircularProgressIndicator();
            } else {
              var state = snapshot.data['state'].toString();

              if (state == '0') {
                return Text(
                  'Waiting for authentication request',
                  style: TextStyle(fontSize: 24, color: Colors.white),
                );
              } else if (state == '1') {
                authenticate();
                return Text(
                  'Authenticating',
                  style: TextStyle(fontSize: 24, color: Colors.white),
                );
              } else if (state == '2') {
                return Text(
                  'User Authenticated',
                  style: TextStyle(fontSize: 24, color: Colors.white),
                );
              } else if (state == '-1') {
                return Text(
                  'User Unauthorized',
                  style: TextStyle(fontSize: 24, color: Colors.white),
                );
              } else {
                changeAuthState(0);
              }
            }
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            changeAuthState('0');
          },
          icon: Icon(
            IconData(0xe5d5, fontFamily: 'MaterialIcons'),
          ),
          label: Text('Reset')),
      backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text('2FA'),
        centerTitle: true,
      ),
      body: Center(
        child: buildAuthCard(),
      ),
    );
  }
}
